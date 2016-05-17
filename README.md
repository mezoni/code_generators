#code_generators
==========

Collection of the template based code generators to simplify the process of generating the source code

Version: 0.0.1

WARNING: IN DEVELOPMENT

Documentation is not available yet but you can get acquainted with the basic principles on the basis of tests.

test/test.dart

```dart
import 'package:code_generators/code_generators.dart';
import 'package:test/test.dart';

void main() {
  testClasses();
  testComments();
  testMetadata();
  testMethods();
  testParameters();
  testTypedefs();
  testVariables();
}

void testClasses() {
  group("Class declaration.", () {
    test("Class signature.", () {
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

    test("Order of members.", () {
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

  static int fooStatic() => 1;

}""";

      var clazz = new ClassGenerator("Foo", isAbstract: true);
      DeclarationGenerator declaration;
      ParametersGenerator parameters;

      // static const int EOF = -1;
      declaration = new VariableGenerator("EOF",
          isConst: true, isStatic: true, type: "int", value: "-1");
      clazz.addStaticConstant(declaration);

      // static int iStatic;
      declaration =
          new VariableGenerator("iStatic", isStatic: true, type: "int");
      clazz.addStaticVariable(declaration);

      // static int get lengthStatic => 0;
      declaration = new MethodGenerator("lengthStatic",
          body: new SimpleGenerator("0"),
          isExpression: true,
          isStatic: true,
          methodType: MethodType.Getter,
          returnType: "int");
      clazz.addStaticProperty(declaration);

      // static int fooStatic() => 1;
      declaration = new MethodGenerator("fooStatic",
          body: new SimpleGenerator("1"),
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
  });
}

void testComments() {
  group("Comments.", () {
    test("Single line.", () {
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

    test("Multi line.", () {
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

    test("Class comment.", () {
      var matcher = """
/// Class [Foo] is a very useful class.
class Foo {
}""";

      var source = "Class [Foo] is a very useful class.";
      var clazz = new ClassGenerator("Foo",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: "/ ", source: source));
      var result = clazz.generate().join("\n");
      expect(result, matcher);
    });

    test("Directive comment.", () {
      // TODO: Implement
    });

    test("Method comment.", () {
      var matcher = """
/// Method [foo] is a very useful method.
void foo() {
}""";

      var source = "Method [foo] is a very useful method.";
      var clazz = new MethodGenerator("foo",
          body: new SimpleGenerator(""),
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: "/ ", source: source),
          returnType: "void");
      var result = clazz.generate().join("\n");
      expect(result, matcher);
    });

    test("Typedef comment.", () {
      var matcher = """
/// Typedef [foo] is a very useful typedef.
typedef int Foo(int i, String s);""";

      var source = "Typedef [foo] is a very useful typedef.";
      var parameters = new ParametersGenerator();
      parameters.addPositional("i", type: "int");
      parameters.addPositional("s", type: "String");
      var declaration = new TypedefGenerator("Foo",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: "/ ", source: source),
          parameters: parameters,
          returnType: "int");
      var result = declaration.generate().join("\n");
      expect(result, matcher);
    });

    test("Variable comment.", () {
      var matcher = """
/// Variable [foo] is a very useful variable.
String foo = 'Foo';""";

      var source = "Variable [foo] is a very useful variable.";
      var clazz = new VariableGenerator("foo",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: "/ ", source: source),
          type: "String",
          value: "'Foo'");
      var result = clazz.generate().join("\n");
      expect(result, matcher);
    });
  });
}

void testMetadata() {
  group("Metadata.", () {
    test("Class metadata.", () {
      var matcher = """
@bar("Foo")
@foo("Bar")
class Foo {
}""";

      var declaration =
          new ClassGenerator("Foo", metadata: ['@foo("Bar")', '@bar("Foo")']);
      var result = declaration.generate().join("\n");
      expect(result, matcher);
    });

    test("Method metadata.", () {
      var matcher = """
@bar("Foo")
@foo("Bar")
void foo();""";

      var declaration = new MethodGenerator("foo",
          metadata: ['@foo("Bar")', '@bar("Foo")'], returnType: "void");
      var result = declaration.generate().join("\n");
      expect(result, matcher);

      matcher = """
@bar("Foo")
@foo("Bar")
int foo() => 0;""";

      declaration = new MethodGenerator("foo",
          body: new SimpleGenerator("0"),
          isExpression: true,
          metadata: ['@foo("Bar")', '@bar("Foo")'],
          returnType: "int");
      result = declaration.generate().join("\n");
      expect(result, matcher);
      matcher = """
@bar("Foo")
@foo("Bar")
int foo() {
  return 0;
}""";

      declaration = new MethodGenerator("foo",
          body: new SimpleGenerator("return 0;"),
          metadata: ['@foo("Bar")', '@bar("Foo")'],
          returnType: "int");
      result = declaration.generate().join("\n");
      expect(result, matcher);
    });

    test("Parameter metadata.", () {
      var matcher = "@NotNull @NotZero int i, @NotFalse bool b";
      var parameters = new ParametersGenerator();
      parameters.addPositional("i",
          metadata: ["@NotNull", "@NotZero"], type: "int");
      parameters.addPositional("b", metadata: ["@NotFalse"], type: "bool");
      var result = parameters.generate().join("\n ");
      expect(result, matcher);
    });

    test("Typedef metadata.", () {
      var matcher = """
@bar("Foo")
@foo("Bar")
typedef int Foo();""";
      var declaration = new TypedefGenerator("Foo",
          metadata: ['@foo("Bar")', '@bar("Foo")'], returnType: "int");
      var result = declaration.generate().join("\n");
      expect(result, matcher);
    });

    test("Variable metadata.", () {
      var matcher = """
@bar("Foo")
@foo("Bar")
final int i = 5;""";

      var declaration = new VariableGenerator("i",
          isFinal: true,
          metadata: ['@foo("Bar")', '@bar("Foo")'],
          type: "int",
          value: "5");
      var result = declaration.generate().join("\n");
      expect(result, matcher);
    });
  });
}

void testMethods() {
  group("Method declaration.", () {
    test("Constructor.", () {
      var matcher = "Foo();";
      var method =
          new MethodGenerator("Foo", methodType: MethodType.Constructor);
      var result = method.generate().join("\n");
      expect(result, matcher);

      var initializers = ["this.x = x", "this.y = 0"];
      var parameters = new ParametersGenerator();
      parameters.addPositional("x", type: "int");
      matcher = "Foo(int x) : this.x = x, this.y = 0;";
      method = new MethodGenerator("Foo",
          initializers: initializers,
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

    test("Expression.", () {
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

    test("Setter.", () {
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

    test("Getter.", () {
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

    test("Method.", () {
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

    test("Operator.", () {
      var matcher = "bool operator ==();";
      var method = new MethodGenerator("==",
          methodType: MethodType.Operator, returnType: "bool");
      var result = method.generate().join("\n");
      expect(result, matcher);
    });

    test("Setter.", () {
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
  group("Parameters declaration.", () {
    test("Named.", () {
      var matcher = "{int i, bool b : true, String s}";
      var parameters = new ParametersGenerator();
      parameters.addNamed("i", type: "int");
      parameters.addNamed("b", type: "bool", defaultValue: "true");
      parameters.addNamed("s", type: "String");
      var result = parameters.generate().join("\n");
      expect(result, matcher);
    });

    test("Optional.", () {
      var matcher = "[int i, bool b = true, String s]";
      var parameters = new ParametersGenerator();
      parameters.addOptional("i", type: "int");
      parameters.addOptional("b", type: "bool", defaultValue: "true");
      parameters.addOptional("s", type: "String");
      var result = parameters.generate().join("\n");
      expect(result, matcher);
    });

    test("Positional.", () {
      var matcher = "int i, bool b, String s";
      var parameters = new ParametersGenerator();
      parameters.addPositional("i", type: "int");
      parameters.addPositional("b", type: "bool");
      parameters.addPositional("s", type: "String");
      var result = parameters.generate().join("\n");
      expect(result, matcher);
    });

    test("Positional and named.", () {
      var matcher = "int i, {bool b : true, String s}";
      var parameters = new ParametersGenerator();
      parameters.addPositional("i", type: "int");
      parameters.addNamed("b", type: "bool", defaultValue: "true");
      parameters.addNamed("s", type: "String");
      var result = parameters.generate().join("\n");
      expect(result, matcher);
    });

    test("Positional and optional.", () {
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

void testTypedefs() {
  group("Typedef declaration.", () {
    test("Typedef signature.", () {
      var matcher = "typedef int Foo(int i, String s);";
      var parameters = new ParametersGenerator();
      parameters.addPositional("i", type: "int");
      parameters.addPositional("s", type: "String");
      var declaration = new TypedefGenerator("Foo",
          parameters: parameters, returnType: "int");
      var result = declaration.generate().join("\n");
      expect(result, matcher);
    });
  });
}

void testVariables() {
  group("Variable declaration.", () {
    test("Constant.", () {
      var matcher = "static const int FOO = 1;";
      var declaration = new VariableGenerator("FOO",
          isConst: true, isStatic: true, type: "int", value: "1");
      var result = declaration.generate().join("\n");
      expect(result, matcher);
    });

    test("Variable.", () {
      var matcher = "final String foo = 'Foo';";
      var declaration = new VariableGenerator("foo",
          isFinal: true, type: "String", value: "'Foo'");
      var result = declaration.generate().join("\n");
      expect(result, matcher);
    });
  });
}

```
