part of code_generators;

class LibraryGenerator extends Object
    with
        GeneratorWithClasses,
        GeneratorWithDirectives,
        GeneratorWithDeclarations,
        GeneratorWithExportDirectives,
        GeneratorWithImportDirectives,
        GeneratorWithLibraryDirective,
        GeneratorWithPartDirectives,
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
{{${DirectiveKey.Part}}}
{{${DeclarationKey.TopLevelConstants}}}
{{${DeclarationKey.TopLevelVariables}}}
{{${DeclarationKey.TopLevelProperties}}}
{{${DeclarationKey.TopLevelMethods}}}
{{${DeclarationKey.Typedefs}}}
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

    keys = <String>[
      DirectiveKey.Export,
      DirectiveKey.Import,
      DirectiveKey.Library,
      DirectiveKey.Part
    ];

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
