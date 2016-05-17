part of code_generators;

class ImperativeGenerator implements Generator {
  List<String> _lines;

  ImperativeGenerator(dynamic source) {
    if (source == null) {
      throw new ArgumentError.notNull("source");
    }

    if (source is String) {
      _lines = const LineSplitter().convert(source);
    } else if (source is List<String>) {
      _lines = source.toList();
    } else {
      throw new ArgumentError.notNull(
          "Argument 'source' should have a type 'String' or 'List<String>'");
    }

    _lines = new List.unmodifiable(_lines);
  }

  List<String> generate() {
    return _lines;
  }
}
