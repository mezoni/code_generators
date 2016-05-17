part of code_generators;

class SourceLinesGenerator implements Generator {
  List<String> _lines;

  SourceLinesGenerator(List<String> lines) {
    if (lines == null) {
      throw new ArgumentError.notNull("lines");
    }

    _lines = lines.toList();
  }

  List<String> generate() {
    return _lines;
  }
}
