part of code_generators;

class TypedefGenerator implements DeclarationGenerator {
  final String name;

  Generator _comment;

  List<String> _metadata;

  Generator _parameters;

  String _returnType;

  TypedefGenerator(this.name,
      {Generator comment,
      List<String> metadata,
      Generator parameters,
      String returnType}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    _comment = comment;
    _metadata = metadata;
    _parameters = parameters;
    _returnType = returnType;
  }

  List<String> generate() {
    var comment = _comment?.generate();
    List<String> metadata;
    if (_metadata != null) {
      metadata = _metadata.toList();
      metadata.sort((a, b) => a.compareTo(b));
    }

    var sb = new StringBuffer();
    _writeSignature(sb);
    sb.write(";");
    var result = <String>[];
    if (comment != null) {
      result.addAll(comment);
    }

    if (metadata != null) {
      result.addAll(metadata);
    }

    result.add(sb.toString());
    return result;
  }

  void _writeSignature(StringBuffer sb) {
    sb.write("typedef ");
    if (_returnType != null) {
      sb.write(_returnType);
      sb.write(" ");
    }

    sb.write(name);
    sb.write("(");
    if (_parameters != null) {
      var result = _parameters.generate();
      sb.write(result.join());
    }

    sb.write(")");
  }
}
