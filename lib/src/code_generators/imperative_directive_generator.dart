part of code_generators;

class ImperativeDirectiveGenerator implements DirectiveGenerator {
  String _key;

  String get key {
    return _key;
  }

  List<String> _lines;

  ImperativeDirectiveGenerator(dynamic source) {
    if (source == null) {
      throw new ArgumentError.notNull("name");
    }

    if (source == null) {
      throw new ArgumentError.notNull("source");
    }

    if (source is String) {
      _key = source;
      _lines = const LineSplitter().convert(source);
    } else if (source is List<String>) {
      _lines = source.toList();
      _key = source.join("\n");
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
