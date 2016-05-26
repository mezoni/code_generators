part of code_generators;

enum CoroutineType { Async, AsyncIterable, SyncIterable }

class MethodGenerator extends Object
    with TemplateGenerator
    implements DeclarationGenerator {
  static const String _TEMPLATE = "_TEMPLATE";

  static const String _template = """
{{#COMMENTS}}
{{#METADATA}}
{{SIGNATURE}} {
  {{#BODY}}
}""";

  final String name;

  Generator _body;

  Generator _comment;

  CoroutineType _coroutineType;

  List<String> _initializers;

  bool _isExpression;

  bool _isFactory;

  bool _isStatic;

  List<String> _metadata;

  MethodType _methodType;

  Generator _parameters;

  String _returnType;

  MethodGenerator(this.name,
      {Generator body,
      Generator comment,
      CoroutineType coroutineType,
      List<String> initializers,
      bool isExpression: false,
      bool isFactory: false,
      bool isStatic: false,
      List<String> metadata,
      MethodType methodType: MethodType.Method,
      Generator parameters,
      String returnType}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    if (isExpression == null) {
      throw new ArgumentError.notNull("isExpression");
    }

    if (isFactory == null) {
      throw new ArgumentError.notNull("isFactory");
    }

    if (isStatic == null) {
      throw new ArgumentError.notNull("isStatic");
    }

    if (methodType == null) {
      throw new ArgumentError.notNull("methodType");
    }

    if (methodType == MethodType.Getter) {
      if (parameters != null) {
        throw new StateError("Getter cannot have a parameter");
      }
    }

    if (isExpression) {
      if (body == null) {
        throw new StateError("Function expression should have a body");
      }
    }

    if (isFactory) {
      if (methodType != MethodType.Constructor) {
        throw new StateError("Only constructor can be a factory");
      }

      if (initializers != null) {
        throw new StateError("Factory constructor cannot have a initializers");
      }

      if (body == null) {
        throw new StateError("Factory constructor should have a body");
      }
    }

    if (isStatic) {
      switch (methodType) {
        case MethodType.Constructor:
          throw new StateError("Constructor cannot be static");
        case MethodType.Operator:
          throw new StateError("Operator cannot be static");
        default:
          break;
      }

      if (body == null) {
        switch (methodType) {
          case MethodType.Getter:
            throw new StateError("Static getter should have a body");
          case MethodType.Method:
            throw new StateError("Static method should have a body");
          case MethodType.Setter:
            throw new StateError("Static setter should have a body");
          default:
            break;
        }
      }
    }

    if (initializers != null) {
      if (methodType != MethodType.Constructor) {
        throw new StateError("Initializers allowed only in constructor");
      }
    }

    if (returnType != null) {
      if (methodType == MethodType.Constructor) {
        throw new StateError("Constructor cannot have a return type");
      }
    }

    addTemplate(_TEMPLATE, _template);
    _body = body;
    _comment = comment;
    _coroutineType = coroutineType;
    _initializers = initializers;
    _isExpression = isExpression;
    _isFactory = isFactory;
    _isStatic = isStatic;
    _metadata = metadata;
    _methodType = methodType;
    _parameters = parameters;
    _returnType = returnType;
  }

  void set body(Generator body) {
    if (body == null) {
      throw new ArgumentError.notNull("body");
    }

    if (_body != null) {
      throw new StateError("Method body already set");
    }

    _body = body;
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
    if (_isExpression) {
      sb.write(" => ");
      sb.write(_body.generate().join());
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

    if (_body == null) {
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

    var block = getTemplateBlock(_TEMPLATE);
    if (comment != null) {
      block.assign("#COMMENTS", comment);
    }

    if (metadata != null) {
      block.assign("#METADATA", metadata);
    }

    block.assign("SIGNATURE", sb.toString());
    block.assign("#BODY", _body.generate());
    return block.process();
  }

  void _writeSignature(StringBuffer sb) {
    if (_isStatic) {
      sb.write("static ");
    }

    if (_isFactory) {
      sb.write("factory ");
    }

    if (_returnType != null) {
      sb.write(_returnType);
      sb.write(" ");
    }

    switch (_methodType) {
      case MethodType.Getter:
        sb.write("get ");
        break;
      case MethodType.Operator:
        sb.write("operator ");
        break;
      case MethodType.Setter:
        sb.write("set ");
        break;
      default:
        break;
    }

    sb.write(name);
    if (_methodType != MethodType.Getter) {
      sb.write("(");
      if (_parameters != null) {
        var result = _parameters.generate();
        sb.write(result.join());
      }

      sb.write(")");
    }

    switch (_coroutineType) {
      case CoroutineType.Async:
        sb.write(" async");
        break;
      case CoroutineType.AsyncIterable:
        sb.write(" async*");
        break;
      case CoroutineType.SyncIterable:
        sb.write(" sync*");
        break;
      default:
        break;
    }

    if (_initializers != null) {
      sb.write(" : ");
      sb.write(_initializers.join(", "));
    }
  }
}

enum MethodType { Constructor, Getter, Method, Operator, Setter }
