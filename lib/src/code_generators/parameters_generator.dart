part of code_generators;

class ParametersGenerator implements Generator {
  List<_Parameter> _named;

  List<_Parameter> _optional;

  List<_Parameter> _positional;

  void addNamed(String name, {String defaultValue, String type}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    if (_optional != null) {
      throw new StateError(
          "Unable to add a named parameter, optional parameter(s) is already specified");
    }

    if (_named == null) {
      _named = <_Parameter>[];
    }

    var parameter =
        new _Parameter(name, defaultValue: defaultValue, type: type);
    _named.add(parameter);
  }

  void addOptional(String name, {String defaultValue, String type}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    if (_named != null) {
      throw new StateError(
          "Unable to add an optional parameter, named parameter(s) is already specified");
    }

    if (_optional == null) {
      _optional = <_Parameter>[];
    }

    var parameter =
        new _Parameter(name, defaultValue: defaultValue, type: type);
    _optional.add(parameter);
  }

  void addPositional(String name, {String type}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    if (_named != null) {
      throw new StateError(
          "Unable to add a positional parameter, named parameter(s) is already specified");
    }

    if (_optional != null) {
      throw new StateError(
          "Unable to add a positional parameter, positional parameter(s) is already specified");
    }

    if (_positional == null) {
      _positional = <_Parameter>[];
    }

    var parameter = new _Parameter(name, type: type);
    _positional.add(parameter);
  }

  List<String> generate() {
    var sb = new StringBuffer();
    if (_positional != null) {
      _writeParameters(_positional, sb, null);
      if (_named != null || _optional != null) {
        sb.write(", ");
      }
    }

    if (_named != null) {
      sb.write("{");
      _writeParameters(_named, sb, true);
      sb.write("}");
    }

    if (_optional != null) {
      sb.write("[");
      _writeParameters(_optional, sb, false);
      sb.write("]");
    }

    return <String>[sb.toString()];
  }

  void _writeParameter(_Parameter parameter, StringBuffer sb, bool isNamed) {
    var type = parameter.type;
    if (type != null) {
      sb.write(type);
      sb.write(" ");
    }

    sb.write(parameter.name);
    var defaultValue = parameter.defaultValue;
    if (defaultValue != null) {
      if (isNamed == true) {
        sb.write(" : ");
      } else if (isNamed == false) {
        sb.write(" = ");
      }

      sb.write(defaultValue);
    }
  }

  void _writeParameters(
      List<_Parameter> parameters, StringBuffer sb, bool isNamed) {
    var length = parameters.length;
    for (var i = 0; i < length; i++) {
      var parameter = parameters[i];
      _writeParameter(parameter, sb, isNamed);
      if (i < length - 1) {
        sb.write(", ");
      }
    }
  }
}

class _Parameter {
  String defaultValue;

  final String name;

  final String type;

  _Parameter(this.name, {this.defaultValue, this.type}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }
  }
}
