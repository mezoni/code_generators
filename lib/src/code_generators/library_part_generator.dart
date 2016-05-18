part of code_generators;

class LibraryPartGenerator extends Object
    with
        GeneratorWithClasses,
        GeneratorWithDirectives,
        GeneratorWithDeclarations,
        GeneratorWithPartOfDirective,
        GeneratorWithTopLevelConstants,
        GeneratorWithTopLevelMethods,
        GeneratorWithTopLevelProperties,
        GeneratorWithTypedefs,
        GeneratorWithTopLevelVariables,
        TemplateGenerator
    implements Generator {
  static const String _TEMPLATE = "_TEMPLATE";

  static const String _template = """
{{${DirectiveKey.Library}}}
{{${DirectiveKey.Import}}}
{{${DirectiveKey.Export}}}
{{${DirectiveKey.Import}}}
{{${DirectiveKey.Part}}}
{{${DeclarationKey.Typedefs}}}
{{${DeclarationKey.TopLevelConstants}}}
{{${DeclarationKey.TopLevelVariables}}}
{{${DeclarationKey.TopLevelProperties}}}
{{${DeclarationKey.TopLevelMethods}}}
{{${DeclarationKey.Classes}}}
""";

  LibraryGenerator() {
    addTemplate(_TEMPLATE, _template);
    var keys = <String>[
      DeclarationKey.Classes,
      DeclarationKey.TopLevelConstants,
      DeclarationKey.TopLevelMethods,
      DeclarationKey.TopLevelProperties,
      DeclarationKey.TopLevelVariables,
      DeclarationKey.Typedefs
    ];

    Map generators = declarationGenerators;
    for (var key in keys) {
      generators[key] = <DeclarationGenerator>[];
    }

    keys = <String>[DirectiveKey.PartOf];

    generators = directiveGenerators;
    for (var key in keys) {
      generators[key] = <DirectiveGenerator>[];
    }
  }

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    generateDerectives(block);
    generateDeclarations(block);
    return block.process();
  }
}
