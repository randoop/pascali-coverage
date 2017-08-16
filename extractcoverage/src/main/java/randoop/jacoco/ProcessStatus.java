package randoop.jacoco;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

import plume.TimeLimitProcess;

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

    // The Plume class used here expects a time limit, but setting tight timeout limits
    // for individual tests has caused headaches when tests are run on Travis CI.
    // 15 minutes is longer than all tests currently take, even for a slow Travis run.
    long timeout = 300000; // use 5 minutes for timeout

    ProcessBuilder randoopBuilder = new ProcessBuilder(command);
    randoopBuilder.directory(workingDirectory.toFile());
    randoopBuilder.redirectErrorStream(true);

    TimeLimitProcess p = null;

    try {
      p = new TimeLimitProcess(randoopBuilder.start(), timeout, true);
    } catch (IOException e) {
      System.err.println("Exception starting process: " + e);
    }

    int exitValue = -1;
    try {
      exitValue = p.waitFor();
    } catch (InterruptedException e) {
      System.err.println("Exception running process: " + e);
    }

    List<String> outputLines = new ArrayList<>();
    try (BufferedReader rdr = new BufferedReader(new InputStreamReader(p.getInputStream()))) {
      String line = rdr.readLine();
      while (line != null) {
        outputLines.add(line);
        line = rdr.readLine();
      }
    } catch (IOException e) {
      System.err.println("Exception getting output " + e);
    }

    if (p.timed_out()) {
      for (String line : outputLines) {
        System.out.println(line);
      }
      assert !p.timed_out() : "Process timed out after " + p.timeout_msecs() + " msecs";
    }
    return new ProcessStatus(command, exitValue, outputLines);
  }
}
