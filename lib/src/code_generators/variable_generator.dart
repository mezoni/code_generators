part of code_generators;

class VariableGenerator implements DeclarationGenerator {
  final String name;

  Generator _comment;

  bool _isConst;

  bool _isFinal;

  bool _isStatic;

  List<String> _metadata;

  String _type;

  String _value;

  VariableGenerator(this.name,
      {Generator comment,
      bool isConst: false,
      bool isFinal: false,
      bool isStatic: false,
      List<String> metadata,
      String type,
      String value}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    if (isConst == null) {
      throw new ArgumentError.notNull("isConst");
    }

    if (isFinal == null) {
      throw new ArgumentError.notNull("isFinal");
    }

    if (isStatic == null) {
      throw new ArgumentError.notNull("isStatic");
    }

    if (isConst) {
      if (value == null) {
        throw new StateError("Constant should have a value");
      }
    }

    _comment = comment;
    _isConst = isConst;
    _isFinal = isFinal;
    _isStatic = isStatic;
    _metadata = metadata;
    _type = type;
    _value = value;
  }

  List<String> generate() {
    var result = <String>[];
    if (_comment != null) {
      result.addAll(_comment.generate());
    }

    if (_metadata != null) {
      var list = _metadata.toList();
      list.sort((a, b) => a.compareTo(b));
      for (var element in list) {
        result.add(element);
      }
    }

    var sb = new StringBuffer();
    if (_isStatic) {
      sb.write("static ");
    }

    if (_isConst) {
      sb.write("const ");
    }

    if (_isFinal) {
      sb.write("final ");
    }

    if (_type != null) {
      sb.write(_type);
      sb.write(" ");
    }

    sb.write(name);
    if (_value != null) {
      sb.write(" = ");
      sb.write(_value);
    }

    sb.write(";");
    result.add(sb.toString());
    return result;
  }
}
