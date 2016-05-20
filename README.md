#code_generators
==========

Collection of the template based code generators to simplify the process of generating the source code.

Version: 0.0.2

**Note: The project is under development (but ready for your experiments).**

Documentation is not available yet but you can get acquainted with the basic principles on the basis of tests.

This software is designed to generate (well formatted) Dart source code by the template based generators (declarative and imperative templates, mixing them to obtain a desired result).

The following basic (declarative) generators provided:

- Library
- Library part
- Class
- Method (constructor, getter, method, operator, setter)
- Variable (field, constant)
- Typedef
- Comment (single and multi line, freely configurable)

Metadata are also supported, but as the imperative specification (ie, as the list of the metadata elements) which will be formatted according to their placement (depending on the kind of declaration).

Example of the declarative generation of the method:

```dart
// Imperative template
var body = """
_length = length;""";

// Declarative generators
var parameters = new ParametersGenerator();
parameters.addPositional("length", type: "int");
var method = new MethodGenerator("length",
    body: new ImperativeGenerator(body),
    methodType: MethodType.Setter,
    parameters: parameters,
    returnType: "void");
var result = method.generate().join("\n");
```

Result (as the lines of the code):

```
void set length(int length) {
  _length = length;
};
```

Also provided an additional (imperative) generators:

- Imperative (any kind of the source code)
- Imperative declaration (any kind of the declaration specified by its name)

Example of the imperative generation of the method:

```dart
// Imperative template
var source = """
void set length(int length) {
  _length = length;
};""";

var method = new ImperativeDeclarationGenerator("length", source);
var result = method.generate().join("\n");
```

Result (as the lines of the code):

```
void set length(int length) {
  _length = length;
};
```

By combining declarative and imperative generators it becomes possible to very flexibly and intelligently generate high quality source code in the form of an list of lines of code (ie, line by line).

This approach preserves formatting (indentation) of source code when are used an insertion of the template in other templates (more precisely templates was not inserted, but inserted the generated results, which are the lines of code in nature).

The following code demonstrates basic the functionality:

[test/test.dart](https://github.com/mezoni/code_generators/blob/master/test/test.dart)

```dart
import 'package:code_generators/code_generators.dart';
import 'package:test/test.dart';

void main() {
  testClasses();
  testComments();
  testDirectives();
  testLibrary();
  testLibraryPart();
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
          body: new ImperativeGenerator("0"),
          isExpression: true,
          isStatic: true,
          methodType: MethodType.Getter,
          returnType: "int");
      clazz.addStaticProperty(declaration);

      // static int fooStatic() => 1;
      declaration = new MethodGenerator("fooStatic",
          body: new ImperativeGenerator("1"),
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
      var matcher = """
/// Directive 'export' is a very useful directive.
export 'foo.dart';""";

      var source = "Directive 'export' is a very useful directive.";
      DirectiveGenerator directive = new ExportDirectiveGenerator("foo.dart",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: "/ ", source: source));
      var result = directive.generate().join("\n");
      expect(result, matcher);

      matcher = """
/// Directive 'import' is a very useful directive.
import 'foo.dart';""";

      source = "Directive 'import' is a very useful directive.";
      directive = new ImportDirectiveGenerator("foo.dart",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: "/ ", source: source));
      result = directive.generate().join("\n");
      expect(result, matcher);

      matcher = """
/// Directive 'library' is a very useful directive.
library foo;""";

      source = "Directive 'library' is a very useful directive.";
      directive = new LibraryDirectiveGenerator("foo",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: "/ ", source: source));
      result = directive.generate().join("\n");
      expect(result, matcher);

      matcher = """
/// Directive 'part' is a very useful directive.
part 'src/foo/foo.dart';""";

      source = "Directive 'part' is a very useful directive.";
      directive = new PartDirectiveGenerator("src/foo/foo.dart",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: "/ ", source: source));
      result = directive.generate().join("\n");
      expect(result, matcher);

      matcher = """
/// Directive 'part of' is a very useful directive.
part of foo;""";

      source = "Directive 'part of' is a very useful directive.";
      directive = new PartOfDirectiveGenerator("foo",
          comment: new CommentGenerator(CommentType.SingleLine,
              prepend: "/ ", source: source));
      result = directive.generate().join("\n");
      expect(result, matcher);
    });

    test("Method comment.", () {
      var matcher = """
/// Method [foo] is a very useful method.
void foo() {
}""";

      var source = "Method [foo] is a very useful method.";
      var clazz = new MethodGenerator("foo",
          body: new ImperativeGenerator(""),
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

void testDirectives() {
  group("Directives.", () {
    test("Directive 'export'.", () {
      var matcher = """
export 'src/foo/foo.dart' show Bang, Foo hide Bar, Baz;""";
      var directive = new ExportDirectiveGenerator("src/foo/foo.dart",
          hide: ["Baz", "Bar"], show: ["Foo", "Bang"]);
      var result = directive.generate().join("\n");
      expect(result, matcher);
    });

    test("Directive 'import'.", () {
      var matcher = """
import 'src/foo/foo.dart' deferred as foo show Bang, Foo hide Bar, Baz;""";
      var directive = new ImportDirectiveGenerator("src/foo/foo.dart",
          hide: ["Baz", "Bar"],
          isDeferred: true,
          prefix: "foo",
          show: ["Foo", "Bang"]);
      var result = directive.generate().join("\n");
      expect(result, matcher);
    });

    test("Directive 'library'.", () {
      var matcher = "library my.cool.library;";
      var directive = new LibraryDirectiveGenerator("my.cool.library");
      var result = directive.generate().join("\n");
      expect(result, matcher);
    });

    test("Directive 'part'.", () {
      var matcher = "part 'src/foo/foo.dart';";
      var directive = new PartDirectiveGenerator("src/foo/foo.dart");
      var result = directive.generate().join("\n");
      expect(result, matcher);
    });

    test("Directive 'part of'.", () {
      var matcher = "part of my.cool.library;";
      var directive = new PartOfDirectiveGenerator("my.cool.library");
      var result = directive.generate().join("\n");
      expect(result, matcher);
    });
  });
}

void testLibrary() {
  group("Library.", () {
    test("Order of members.", () {
      var matcher = """
library foo;

import 'baz.dart';

export 'baz.dart';

part 'src/foo/foo.dart';

const int FOO = 0;

var s = 'Hello';

int get x => 1;

void foo() {
}

typedef A();

class Foo {
}

""";

      var script = new LibraryGenerator();
      // library foo;
      script.addLibrary(new LibraryDirectiveGenerator("foo"));

      // import "baz.dart";
      script.addImport(new ImportDirectiveGenerator("baz.dart"));

      // export "baz.dart";
      script.addExport(new ExportDirectiveGenerator("baz.dart"));

      // export "baz.dart";
      script.addPart(new PartDirectiveGenerator("src/foo/foo.dart"));

      // const int FOO = 0;
      script.addTopLevelConstant(
          new VariableGenerator("FOO", isConst: true, type: "int", value: "0"));

      // var s = "Hello";
      script.addTopLevelVariable(
          new VariableGenerator("s", type: "var", value: "'Hello'"));

      // int get x => 1;
      script.addTopLevelProperty(new MethodGenerator("x",
          body: new ImperativeGenerator("1"),
          isExpression: true,
          methodType: MethodType.Getter,
          returnType: "int"));

      // void foo() {
      // }
      script.addTopLevelMethod(new MethodGenerator("foo",
          body: new ImperativeGenerator(""), returnType: "void"));

      // typedef A();
      script.addTypedef(new TypedefGenerator("A"));

      // class Foo {
      // }
      script.addClass(new ClassGenerator("Foo"));

      var result = script.generate().join("\n");
      expect(result, matcher);
    });
  });
}

void testLibraryPart() {
  group("Library part.", () {
    test("Order of members.", () {
      var matcher = """
part of foo;

const int FOO = 0;

var s = 'Hello';

int get x => 1;

void foo() {
}

typedef A();

class Foo {
}

""";

      var script = new LibraryPartGenerator();
      // part of  foo;
      script.addPartOf(new PartOfDirectiveGenerator("foo"));

      // const int FOO = 0;
      script.addTopLevelConstant(
          new VariableGenerator("FOO", isConst: true, type: "int", value: "0"));

      // var s = "Hello";
      script.addTopLevelVariable(
          new VariableGenerator("s", type: "var", value: "'Hello'"));

      // int get x => 1;
      script.addTopLevelProperty(new MethodGenerator("x",
          body: new ImperativeGenerator("1"),
          isExpression: true,
          methodType: MethodType.Getter,
          returnType: "int"));

      // void foo() {
      // }
      script.addTopLevelMethod(new MethodGenerator("foo",
          body: new ImperativeGenerator(""), returnType: "void"));

      // typedef A();
      script.addTypedef(new TypedefGenerator("A"));

      // class Foo {
      // }
      script.addClass(new ClassGenerator("Foo"));

      var result = script.generate().join("\n");
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

    test("Directive metadata.", () {
      var matcher = """
@bar("Foo")
@foo("Bar")
import 'foo.dart';""";

      var directive = new ImportDirectiveGenerator("foo.dart",
          metadata: ['@foo("Bar")', '@bar("Foo")']);
      var result = directive.generate().join("\n");
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
          body: new ImperativeGenerator("0"),
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
          body: new ImperativeGenerator("return 0;"),
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
          body: new ImperativeGenerator("new Foo._internal(other)"),
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
          body: new ImperativeGenerator(body),
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
          body: new ImperativeGenerator(body),
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
          body: new ImperativeGenerator(body),
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
          body: new ImperativeGenerator(body),
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
          body: new ImperativeGenerator(body),
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
          body: new ImperativeGenerator(body),
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
          body: new ImperativeGenerator(body),
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
          body: new ImperativeGenerator(body),
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
