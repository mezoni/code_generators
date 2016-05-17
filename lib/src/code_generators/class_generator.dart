part of code_generators;

class ClassGenerator extends Object
    with
        GeneratorWithConstructors,
        GeneratorWithDeclarations,
        GeneratorWithMethods,
        GeneratorWithOperators,
        GeneratorWithProperties,
        GeneratorWithStaticConstants,
        GeneratorWithStaticMethods,
        GeneratorWithStaticProperties,
        GeneratorWithStaticVariables,
        GeneratorWithVariables,
        TemplateGenerator
    implements DeclarationGenerator {
  static const String _TEMPLATE = "_TEMPLATE";

  static const String _template = """
{{#COMMENTS}}
{{#METADATA}}
{{SIGNATURE}} {
  {{#PROLOGUE}}
  {{${DeclarationKey.StaticConstants}}}
  {{${DeclarationKey.StaticVariables}}}
  {{${DeclarationKey.StaticProperties}}}
  {{${DeclarationKey.Variables}}}
  {{${DeclarationKey.Constructors}}}
  {{${DeclarationKey.Properties}}}
  {{${DeclarationKey.Operators}}}
  {{${DeclarationKey.Methods}}}
  {{${DeclarationKey.StaticMethods}}}
  {{#EPILOGUE}}
}""";

  final String name;

  Generator _comment;

  List<String> _interfaces;

  bool _isAbstract;

  List<String> _mixins;

  String _superclass;

  ClassGenerator(this.name,
      {Generator comment,
      bool isAbstract: false,
      List<String> interfaces,
      List<String> mixins,
      String superclass}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    if (isAbstract == null) {
      throw new ArgumentError.notNull("isAbstract");
    }

    addTemplate(_TEMPLATE, _template);
    _comment = comment;
    _interfaces = interfaces?.toList();
    _isAbstract = isAbstract;
    _mixins = mixins?.toList();
    _superclass = superclass;
    var generators = declarationGenerators;
    generators[DeclarationKey.StaticConstants] = <DeclarationGenerator>[];
    generators[DeclarationKey.StaticVariables] = <DeclarationGenerator>[];
    generators[DeclarationKey.StaticProperties] = <DeclarationGenerator>[];
    generators[DeclarationKey.StaticMethods] = <DeclarationGenerator>[];
    generators[DeclarationKey.Variables] = <DeclarationGenerator>[];
    generators[DeclarationKey.Constructors] = <DeclarationGenerator>[];
    generators[DeclarationKey.Operators] = <DeclarationGenerator>[];
    generators[DeclarationKey.Properties] = <DeclarationGenerator>[];
    generators[DeclarationKey.Methods] = <DeclarationGenerator>[];
  }

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    generateDeclarations(block);
    var sb = new StringBuffer();
    _writeSignature(sb);
    if (_comment != null) {
      block.assign("#COMMENTS", _comment.generate());
    }

    block.assign("SIGNATURE", sb.toString());
    return block.process();
  }

  void _writeSignature(StringBuffer sb) {
    if (_isAbstract) {
      sb.write("abstract ");
    }

    sb.write("class ");
    sb.write(name);
    if (_superclass != null) {
      sb.write(" extends ");
      sb.write(_superclass);
    }

    if (_mixins != null) {
      sb.write(" with ");
      var list = _mixins.toList();
      list.sort((a, b) => a.compareTo(b));
      sb.write(list.join(", "));
    }

    if (_interfaces != null) {
      sb.write(" implements ");
      var list = _interfaces.toList();
      list.sort((a, b) => a.compareTo(b));
      sb.write(list.join(", "));
    }
  }
}
