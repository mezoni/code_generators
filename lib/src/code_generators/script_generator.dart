part of code_generators;

class ScriptGenerator extends Object
    with
        GeneratorWithClasses,
        GeneratorWithDeclarations,
        GeneratorWithTopLevelMethods,
        GeneratorWithTopLevelVariables,
        TemplateGenerator
    implements Generator {
  static const String _TEMPLATE = "_TEMPLATE";

  static const String _template = """
{{#PROLOGUE}}
{{#TYPEDEFS}}
{{${DeclarationKey.TopLevelConstants}}}
{{${DeclarationKey.TopLevelVariables}}}
{{${DeclarationKey.TopLevelProperties}}}
{{${DeclarationKey.TopLevelMethods}}}
{{${DeclarationKey.Classes}}}
{{#EPILOGUE}}
""";

  ScriptGenerator() {
    addTemplate(_TEMPLATE, _template);
    var generators = declarationGenerators;
    generators[DeclarationKey.Classes] = <DeclarationGenerator>[];
    generators[DeclarationKey.TopLevelConstants] = <DeclarationGenerator>[];
    generators[DeclarationKey.TopLevelMethods] = <DeclarationGenerator>[];
    generators[DeclarationKey.TopLevelProperties] = <DeclarationGenerator>[];
    generators[DeclarationKey.TopLevelVariables] = <DeclarationGenerator>[];
  }

  List<String> generate() {
    var block = getTemplateBlock(_TEMPLATE);
    generateDeclarations(block);
    return block.process();
  }
}
