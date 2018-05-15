package randoop.jacoco;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecuteResultHandler;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteWatchdog;
import org.apache.commons.exec.PumpStreamHandler;


/**
 * Class to hold the return status from running a command assuming that it
 * is run in a process where stderr and stdout are linked.
 * Includes the exit status, and the list of output lines.
 */
class ProcessStatus {

  /** The command executed by the process. */
  final List<String> command;

  /** The exit status of the command. */
  final int exitStatus;

  /** The output from running the command. */
  final List<String> outputLines;

  static final String lineSep = System.getProperty("line.separator");

  /**
   * Creates a {@link ProcessStatus} object for the command with captured exit status, and output.
   *
   * @param command  the command
   * @param exitStatus  the exit status
   * @param outputLines  the lines of process output
   */
  private ProcessStatus(List<String> command, int exitStatus, List<String> outputLines) {
    this.command = command;
    this.exitStatus = exitStatus;
    this.outputLines = outputLines;
  }

  /**
   * Runs the given command in a new process using the given timeout.
   * <p>
   * The process is run with a timeout of 15 minutes.
   *
   * @param command  the command to be run in the process
   * @return the exit status and combined standard stream output
   */
  static ProcessStatus runCommand(List<String> command, Path workingDirectory) {

    // Setting tight timeout limits for individual tests has caused headaches when
    // tests are run on Travis CI.  We will use 5 minutes for timeout length.
    long timeout = 300000;

    String[] args = command.toArray(new String[0]);
    CommandLine cmdLine = new CommandLine(args[0]); // constructor requires executable name
    cmdLine.addArguments(Arrays.copyOfRange(args, 1, args.length));

    DefaultExecuteResultHandler resultHandler = new DefaultExecuteResultHandler();
    DefaultExecutor executor = new DefaultExecutor();
    executor.setWorkingDirectory(workingDirectory.toFile());

    ExecuteWatchdog watchdog = new ExecuteWatchdog(timeout);
    executor.setWatchdog(watchdog);

    final ByteArrayOutputStream outStream = new ByteArrayOutputStream();
    PumpStreamHandler streamHandler = new PumpStreamHandler(outStream); // capture both stderr and stdout
    executor.setStreamHandler(streamHandler);

    try {
      executor.execute(cmdLine, resultHandler);
    } catch (IOException e) {
      System.err.println("Exception starting process: " + e);
    }

    int exitValue = -1;
    try {
      resultHandler.waitFor();
      exitValue = resultHandler.getExitValue();
    } catch (InterruptedException e) {
      if (!watchdog.killedProcess()) {
        System.err.println("Exception running process: " + e);
      }
    }
    boolean timedOut = executor.isFailure(exitValue) && watchdog.killedProcess();

    List<String> outputLines = new ArrayList<>();
    try {
      outputLines = Arrays.asList(outStream.toString().split(lineSep));
    } catch (RuntimeException e) {
      System.err.println("Exception getting output " + e);
    }

    if (timedOut) {
      for (String line : outputLines) {
        System.out.println(line);
      }
      System.err.println("Process timed out after " + timeout + " msecs.");
    }
    return new ProcessStatus(command, exitValue, outputLines);
  }
}
