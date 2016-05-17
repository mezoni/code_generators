part of code_generators;

class VariableGenerator implements DeclarationGenerator {
  final String name;

  bool _isConst;

  bool _isStatic;

  String _type;

  String _value;

  VariableGenerator(this.name,
      {bool isConst: false, bool isStatic: false, String type, String value}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    if (isConst == null) {
      throw new ArgumentError.notNull("isConst");
    }

    if (isStatic == null) {
      throw new ArgumentError.notNull("isStatic");
    }

    if (isConst) {
      if (value == null) {
        throw new StateError("Constant should have a value");
      }

      if (!isStatic) {
        throw new StateError("Constant should be static");
      }
    }

    _isConst = isConst;
    _isStatic = isStatic;
    _type = type;
    _value = value;
  }

  List<String> generate() {
    var sb = new StringBuffer();
    if (_isStatic) {
      sb.write("static ");
    }

    if (_isConst) {
      sb.write("const ");
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
    return <String>[sb.toString()];
  }
}
