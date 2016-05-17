part of code_generators;

class CommentGenerator extends Object with TemplateGenerator {
  String _first;

  String _last;

  List<String> _lines;

  String _prepend;

  CommentType _type;

  CommentGenerator(CommentType type,
      {String first: "", String last: "", String prepend: "", dynamic source}) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    if (first == null) {
      throw new ArgumentError.notNull("first");
    }

    if (last == null) {
      throw new ArgumentError.notNull("last");
    }

    if (prepend == null) {
      throw new ArgumentError.notNull("prepend");
    }

    _lines = <String>[];
    if (source is String) {
      _lines.addAll(const LineSplitter().convert(source));
    } else if (source is List<String>) {
      _lines.addAll(source);
    } else if (source != null) {
      throw new ArgumentError.notNull(
          "Argument 'source' should have a type 'String' or 'List<String>'");
    }

    _first = first;
    _last = last;
    _prepend = prepend;
    _type = type;
  }

  void addLine(String line) {
    if (line == null) {
      throw new ArgumentError.notNull("line");
    }

    var list = const LineSplitter().convert(line);
    _lines.addAll(list);
  }

  void addLines(dynamic source) {
    if (source == null) {
      throw new ArgumentError.notNull("source");
    }

    List<String> list;
    if (source is String) {
      list = const LineSplitter().convert(source);
    } else if (source is List<String>) {
      list = source;
    } else {
      throw new ArgumentError.notNull(
          "Argument 'source' should have a type 'String' or 'List<String>'");
    }

    _lines.addAll(list);
  }

  List<String> generate() {
    var result = <String>[];
    if (_type == CommentType.MultiLine) {
      result.add("/*$_first");
    }

    var prepend = _prepend;
    if (_type == CommentType.SingleLine) {
      prepend = "//$prepend";
    } else {
      prepend = " $prepend";
    }

    var length = _lines.length;
    for (var i = 0; i < length; i++) {
      var line = _lines[i];
      result.add("$prepend$line");
    }

    if (_type == CommentType.MultiLine) {
      result.add(" $_last*/");
    }

    return result;
  }
}

enum CommentType { MultiLine, SingleLine }
