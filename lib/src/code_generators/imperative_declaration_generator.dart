part of code_generators;

class ImperativeDeclarationGenerator implements DeclarationGenerator {
  final String name;

  List<String> _lines;

  ImperativeDeclarationGenerator(this.name, dynamic source) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

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
