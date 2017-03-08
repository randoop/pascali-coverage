package randoop.jacoco;

import java.nio.file.FileSystems;
import java.nio.file.FileVisitResult;
import java.nio.file.Path;
import java.nio.file.PathMatcher;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.Set;

import static java.nio.file.FileVisitResult.CONTINUE;

public class CollectClassFiles extends SimpleFileVisitor<Path> {

  private final PathMatcher classFileMatcher = FileSystems.getDefault().getPathMatcher("glob:**.class");
  private final Path rootPath;
  private final Set<String> classes;

  public CollectClassFiles(Path rootPath, Set<String> classes) {
    this.rootPath = rootPath.normalize();
    this.classes = classes;
  }

  @Override
  public FileVisitResult visitFile(Path file, BasicFileAttributes attributes) {
    if (attributes.isRegularFile()) {
      if (classFileMatcher.matches(file)) {
        String pathString = rootPath.relativize(file).toString();
        String classFilename = pathString.substring(0, pathString.lastIndexOf(".class")).replace('/','.').replace('$','.');
        classes.add(classFilename);
      }
    }
    return CONTINUE;
  }
}
