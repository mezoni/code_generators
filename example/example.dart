import 'package:code_generators/code_generators.dart';

void main() {
  var generator = new _Generator();
  var result = generator.generate();
  print(result.join("\n"));
}

class _Generator implements Generator {
  static const String _Baz = "Baz";

  static const String _Foo = "Foo";

  static const String _foo = "foo";

  static const String _fooAsync = "fooAsync";

  List<String> generate() {
    var script = new LibraryGenerator();
    _generate_Baz(script);
    _generate_Foo(script);
    return script.generate();
  }

  void _generate_Baz(LibraryGenerator script) {
    var clazz = new ClassGenerator(_Baz);
    _generate_Baz_bar(clazz);
    script.addClass(clazz);
  }

  void _generate_Foo(LibraryGenerator script) {
    var clazz = new ClassGenerator(_Foo, mixins: [_Baz], superclass: "Object");
    _generate_Foo_eq(clazz);
    _generate_Foo_foo(clazz);
    _generate_Foo_fooAsync(clazz);
    script.addClass(clazz);
  }

  void _generate_Baz_bar(ClassGenerator clazz) {
    final String source = """
bool bar(int i) {
  return i == 41;
}
""";

    var method = new ImperativeDeclarationGenerator("bar", source);
    clazz.addMethod(method);
  }

  void _generate_Foo_fooAsync(ClassGenerator clazz) {
    final String body = """
return 41;
""";

    var method = new MethodGenerator(_fooAsync,
        body: new ImperativeGenerator(body),
        coroutineType: CoroutineType.Async,
        returnType: "Future<int>");
    clazz.addMethod(method);
  }

  void _generate_Foo_eq(ClassGenerator clazz) {
    final String body = """
if (other is $_Foo) {
  return other.id = this.id;
};

return false;""";

    var parameters = new ParametersGenerator();
    parameters.addPositional("other");
    var method = new MethodGenerator("==",
        body: new ImperativeGenerator(body),
        methodType: MethodType.Operator,
        parameters: parameters,
        returnType: "bool");
    clazz.addMethod(method);
  }

  void _generate_Foo_foo(ClassGenerator clazz) {
    final String body = """
if(a == b) {
  return 1;
} else {
  return 2;
}""";

    var parameters = new ParametersGenerator();
    parameters.addPositional("a");
    parameters.addPositional("b");
    var method = new MethodGenerator(_foo,
        body: new ImperativeGenerator(body),
        parameters: parameters,
        returnType: "int");
    clazz.addMethod(method);
  }
}
