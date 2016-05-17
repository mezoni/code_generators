import 'package:code_generators/code_generators.dart';
import 'package:test/test.dart';

void main() {
  testClasses();
  testComments();
  testMethods();
  testParameters();
  // Variables
}

void testClasses() {
  group("Class declaration", () {
    test("Class signature", () {
      var matcher = """
abstract class FooImpl extends Object with BarBase, ListBase implements IBaz, IFoo {
}""";
      var clazz = new ClassGenerator("FooImpl",
          isAbstract: true,
          interfaces: ["IFoo", "IBaz"],
          mixins: ["ListBase", "BarBase"],
          superclass: "Object");
      var result = clazz.generate().join("\n");
      expect(result, matcher);
    });
  });

  test("Members ", () {
    var matcher = """
abstract class Foo {
  static const int EOF = -1;

  static int iStatic;

  static int get lengthStatic => 0;

  Foo();

  int get length;

  void set length(int length);

  bool operator ==(other);

  void foo();

  static int fooStatic() => 0;

}""";

    var clazz = new ClassGenerator("Foo", isAbstract: true);
    DeclarationGenerator declaration;
    ParametersGenerator parameters;

    // static const int EOF = -1;
    declaration = new VariableGenerator("EOF",
        isConst: true, isStatic: true, type: "int", value: "-1");
    clazz.addStaticConstant(declaration);

    // static int iStatic;
    declaration = new VariableGenerator("iStatic", isStatic: true, type: "int");
    clazz.addStaticVariable(declaration);

    // static int get lengthStatic;
    declaration = new MethodGenerator("lengthStatic",
        body: new SimpleGenerator("0"),
        isExpression: true,
        isStatic: true,
        methodType: MethodType.Getter,
        returnType: "int");
    clazz.addStaticProperty(declaration);

    // static void fooStatic();
    declaration = new MethodGenerator("fooStatic",
        body: new SimpleGenerator("0"),
        isExpression: true,
        isStatic: true,
        returnType: "int");
    clazz.addStaticMethod(declaration);

    // Foo();
    declaration =
        new MethodGenerator("Foo", methodType: MethodType.Constructor);
    clazz.addConstructor(declaration);

    // bool operator ==(other);
    parameters = new ParametersGenerator();
    parameters.addPositional("other");
    declaration = new MethodGenerator("==",
        methodType: MethodType.Operator,
        parameters: parameters,
        returnType: "bool");
    clazz.addOperator(declaration);

    // int get length;
    parameters = new ParametersGenerator();
    declaration = new MethodGenerator("length",
        methodType: MethodType.Getter, returnType: "int");
    clazz.addProperty(declaration);

    // void set length(int length);
    parameters = new ParametersGenerator();
    parameters.addPositional("length", type: "int");
    declaration = new MethodGenerator("length",
        methodType: MethodType.Setter,
        parameters: parameters,
        returnType: "void");
    clazz.addProperty(declaration);

    // void foo();
    declaration = new MethodGenerator("foo", returnType: "void");
    clazz.addMethod(declaration);

    // Test
    var result = clazz.generate().join("\n");
    expect(result, matcher);
  });
}

void testComments() {
  group("Comments", () {
    test("Single line", () {
      var source = """
This is a comment.
This is also a comment.""";

      var matcher = """
/// This is a comment.
/// This is also a comment.
class Foo {
  /// This is a comment.
  /// This is also a comment.
  foo();

}""";

      var clazz = new ClassGenerator("Foo",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: "/ ", source: source));
      var method = new MethodGenerator("foo",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: "/ ", source: source));
      clazz.addMethod(method);
      var result = clazz.generate().join("\n");
      expect(result, matcher);

      matcher = """
// This is a comment.
// This is also a comment.
class Foo {
  // This is a comment.
  // This is also a comment.
  foo();

}""";

      clazz = new ClassGenerator("Foo",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: " ", source: source));
      method = new MethodGenerator("foo",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: " ", source: source));
      clazz.addMethod(method);
      result = clazz.generate().join("\n");
      expect(result, matcher);
    });

    test("Multi line", () {
      var source = """
This is a comment.
This is also a comment.""";

      var matcher = """
/**
 * This is a comment.
 * This is also a comment.
 */
class Foo {
  /**
   * This is a comment.
   * This is also a comment.
   */
  foo();

}""";

      var clazz = new ClassGenerator("Foo",
          comment: new CommentGenerator(CommentType.MultiLine,
              first: "*", prepend: "* ", source: source));
      var method = new MethodGenerator("foo",
          comment: new CommentGenerator(CommentType.MultiLine,
              first: "*", prepend: "* ", source: source));
      clazz.addMethod(method);
      var result = clazz.generate().join("\n");
      expect(result, matcher);

      matcher = """
/*
 * This is a comment.
 * This is also a comment.
 */
class Foo {
  /*
   * This is a comment.
   * This is also a comment.
   */
  foo();

}""";

      clazz = new ClassGenerator("Foo",
          comment: new CommentGenerator(CommentType.MultiLine,
              prepend: "* ", source: source));
      method = new MethodGenerator("foo",
          comment: new CommentGenerator(CommentType.MultiLine,
              prepend: "* ", source: source));
      clazz.addMethod(method);
      result = clazz.generate().join("\n");
      expect(result, matcher);
    });
  });
}

void testMethods() {
  group("Method declaration", () {
    test("Constructor", () {
      var matcher = "Foo();";
      var method =
          new MethodGenerator("Foo", methodType: MethodType.Constructor);
      var result = method.generate().join("\n");
      expect(result, matcher);

      var initializers = ["this.x = x"];
      var parameters = new ParametersGenerator();
      parameters.addPositional("x", type: "int");
      matcher = "Foo(int x) : this.x = x;";
      method = new MethodGenerator("Foo",
          initializers: new SourceLinesGenerator(initializers),
          parameters: parameters,
          methodType: MethodType.Constructor);
      result = method.generate().join("\n");
      expect(result, matcher);

      matcher = "factory Foo.from(Foo other) => new Foo._internal(other);";
      parameters = new ParametersGenerator();
      parameters.addPositional("other", type: "Foo");
      method = new MethodGenerator("Foo.from",
          body: new SimpleGenerator("new Foo._internal(other)"),
          isExpression: true,
          isFactory: true,
          methodType: MethodType.Constructor,
          parameters: parameters);
      result = method.generate().join("\n");
      expect(result, matcher);
      expect(result, matcher);
    });

    test("Setter", () {
      var matcher = """
void set length(int length) {
  _length = length;
}""";

      var body = """
_length = length;""";

      var parameters = new ParametersGenerator();
      parameters.addPositional("length", type: "int");
      var method = new MethodGenerator("length",
          body: new SimpleGenerator(body),
          methodType: MethodType.Setter,
          parameters: parameters,
          returnType: "void");
      var result = method.generate().join("\n");
      expect(result, matcher);
    });

    test("Expression", () {
      var matcher = "bool sum(a, b) => a + b;";
      var body = "a + b";
      var parameters = new ParametersGenerator();
      parameters.addPositional("a");
      parameters.addPositional("b");
      var method = new MethodGenerator("sum",
          body: new SimpleGenerator(body),
          isExpression: true,
          parameters: parameters,
          returnType: "bool");
      var result = method.generate().join("\n");
      expect(result, matcher);
    });

    test("Setter", () {
      var matcher = """
void set length(int length) {
  _length = length;
}""";

      var body = """
_length = length;""";

      var parameters = new ParametersGenerator();
      parameters.addPositional("length", type: "int");
      var method = new MethodGenerator("length",
          body: new SimpleGenerator(body),
          methodType: MethodType.Setter,
          parameters: parameters,
          returnType: "void");
      var result = method.generate().join("\n");
      expect(result, matcher);
    });

    test("Getter", () {
      var matcher = """
int get length {
  return _length;
}""";

      var body = """
return _length;""";

      var method = new MethodGenerator("length",
          body: new SimpleGenerator(body),
          methodType: MethodType.Getter,
          returnType: "int");
      var result = method.generate().join("\n");
      expect(result, matcher);
    });

    test("Method", () {
      var matcher = "int foo();";
      var method = new MethodGenerator("foo", returnType: "int");
      var result = method.generate().join("\n");
      expect(result, matcher);

      // async
      matcher = """
Future<int> foo() async {
  if (true) {
    return 41;
  }
}""";

      var body = """
if (true) {
  return 41;
}""";
      method = new MethodGenerator("foo",
          body: new SimpleGenerator(body),
          coroutineType: CoroutineType.Async,
          returnType: "Future<int>");
      result = method.generate().join("\n");
      expect(result, matcher);

      // async*
      matcher = """
Stream<int> foo() async* {
  if (true) {
    return [41];
  }
}""";

      body = """
if (true) {
  return [41];
}""";
      method = new MethodGenerator("foo",
          body: new SimpleGenerator(body),
          coroutineType: CoroutineType.AsyncIterable,
          returnType: "Stream<int>");
      result = method.generate().join("\n");
      expect(result, matcher);

      // sync*
      matcher = """
Iterable<int> foo() sync* {
  if (true) {
    return [41];
  }
}""";

      body = """
if (true) {
  return [41];
}""";
      method = new MethodGenerator("foo",
          body: new SimpleGenerator(body),
          coroutineType: CoroutineType.SyncIterable,
          returnType: "Iterable<int>");
      result = method.generate().join("\n");
      expect(result, matcher);
    });

    test("Operator", () {
      var matcher = "bool operator ==();";
      var method = new MethodGenerator("==",
          methodType: MethodType.Operator, returnType: "bool");
      var result = method.generate().join("\n");
      expect(result, matcher);
    });

    test("Setter", () {
      var matcher = """
void set length(int length) {
  _length = length;
}""";

      var body = """
_length = length;""";

      var parameters = new ParametersGenerator();
      parameters.addPositional("length", type: "int");
      var method = new MethodGenerator("length",
          body: new SimpleGenerator(body),
          methodType: MethodType.Setter,
          parameters: parameters,
          returnType: "void");
      var result = method.generate().join("\n");
      expect(result, matcher);
    });
  });
}

void testParameters() {
  group("Parameters declaration", () {
    test("Named", () {
      var matcher = "{int i, bool b : true, String s}";
      var parameters = new ParametersGenerator();
      parameters.addNamed("i", type: "int");
      parameters.addNamed("b", type: "bool", defaultValue: "true");
      parameters.addNamed("s", type: "String");
      var result = parameters.generate().join("\n");
      expect(result, matcher);
    });

    test("Optional", () {
      var matcher = "[int i, bool b = true, String s]";
      var parameters = new ParametersGenerator();
      parameters.addOptional("i", type: "int");
      parameters.addOptional("b", type: "bool", defaultValue: "true");
      parameters.addOptional("s", type: "String");
      var result = parameters.generate().join("\n");
      expect(result, matcher);
    });

    test("Positional", () {
      var matcher = "int i, bool b, String s";
      var parameters = new ParametersGenerator();
      parameters.addPositional("i", type: "int");
      parameters.addPositional("b", type: "bool");
      parameters.addPositional("s", type: "String");
      var result = parameters.generate().join("\n");
      expect(result, matcher);
    });

    test("Positional and named", () {
      var matcher = "int i, {bool b : true, String s}";
      var parameters = new ParametersGenerator();
      parameters.addPositional("i", type: "int");
      parameters.addNamed("b", type: "bool", defaultValue: "true");
      parameters.addNamed("s", type: "String");
      var result = parameters.generate().join("\n");
      expect(result, matcher);
    });

    test("Positional and optional", () {
      var matcher = "int i, [bool b = true, String s]";
      var parameters = new ParametersGenerator();
      parameters.addPositional("i", type: "int");
      parameters.addOptional("b", type: "bool", defaultValue: "true");
      parameters.addOptional("s", type: "String");
      var result = parameters.generate().join("\n");
      expect(result, matcher);
    });
  });
}
