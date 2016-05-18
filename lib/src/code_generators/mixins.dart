part of code_generators;

class DeclarationKey {
  static const String Classes = "#CLASSES";

  static const String Constructors = "#CONSTRUCTORS";

  static const String Methods = "#METHODS";

  static const String Operators = "#OPERATORS";

  static const String Properties = "#PROPERTIES";

  static const String StaticConstants = "#STATIC_CONSTANTS";

  static const String StaticMethods = "#STATIC_METHODS";

  static const String StaticProperties = "#STATIC_PROPERTIES";

  static const String StaticVariables = "#STATIC_VARIABLES";

  static const String TopLevelConstants = "#TOP_LEVEL_CONSTANTS";

  static const String TopLevelMethods = "#TOP_LEVEL_METHODS";

  static const String TopLevelProperties = "#TOP_LEVEL_PROPERTIES";

  static const String TopLevelVariables = "#TOP_LEVEL_VARIABLES";

  static const String Typedefs = "#TYPEDEFS";

  static const String Variables = "#VARIABLES";
}

class DirectiveKey {
  static const String Export = "#EXPORT";

  static const String Import = "#IMPORT";

  static const String Library = "#LIBRARY";

  static const String Part = "#PART";

  static const String PartOf = "#PART_OF";
}

abstract class GeneratorWithClasses extends Object
    with GeneratorWithDeclarations {
  void addClass(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.Classes);
  }
}

abstract class GeneratorWithConstructors extends Object
    with GeneratorWithDeclarations {
  void addConstructor(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.Constructors);
  }
}

abstract class GeneratorWithDeclarations {
  Map<String, List<DeclarationGenerator>> _declarationGenerators =
      <String, List<DeclarationGenerator>>{};

  Map<String, List<DeclarationGenerator>> get declarationGenerators {
    return _declarationGenerators;
  }

  void addDeclaration(DeclarationGenerator declaration, String key) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    if (key == null) {
      throw new ArgumentError.notNull(key);
    }

    var generators = _declarationGenerators[key];
    if (generators == null) {
      throw new ArgumentError("Declaration key '$key' not found");
    }

    generators.add(declaration);
  }

  void generateDeclarations(TemplateBlock block) {
    var keys = _declarationGenerators.keys.toList();
    var count = keys.length;
    for (var i = 0; i < count; i++) {
      var key = keys[i];
      var generators = _declarationGenerators[key].toList();
      generators.sort((a, b) => a.name.compareTo(b.name));
      for (var generator in generators) {
        var result = generator.generate().toList();
        var length = result.length;
        if (length > 0) {
          result[length - 1] += "\n";
        }

        block.assign(key, result);
      }
    }
  }
}

abstract class GeneratorWithDirectives {
  Map<String, List<DeclarationGenerator>> _directiveGenerators =
      <String, List<DeclarationGenerator>>{};

  Map<String, List<DeclarationGenerator>> get directiveGenerators {
    return _directiveGenerators;
  }

  void addDirective(DeclarationGenerator directive, String key) {
    if (directive == null) {
      throw new ArgumentError.notNull("directive");
    }

    if (key == null) {
      throw new ArgumentError.notNull(key);
    }

    var generators = _directiveGenerators[key];
    if (generators == null) {
      throw new ArgumentError("Directive key '$key' not found");
    }

    generators.add(directive);
  }

  void generateDerectives(TemplateBlock block) {
    var keys = _directiveGenerators.keys.toList();
    var count = keys.length;
    for (var i = 0; i < count; i++) {
      var key = keys[i];
      var generators = _directiveGenerators[key].toList();
      generators.sort((a, b) => a.name.compareTo(b.name));
      for (var generator in generators) {
        var result = generator.generate().toList();
        var length = result.length;
        if (length > 0) {
          result[length - 1] += "\n";
        }

        block.assign(key, result);
      }
    }
  }
}

abstract class GeneratorWithMethods extends Object
    with GeneratorWithDeclarations {
  void addMethod(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.Methods);
  }
}

abstract class GeneratorWithOperators extends Object
    with GeneratorWithDeclarations {
  void addOperator(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.Operators);
  }
}

abstract class GeneratorWithProperties extends Object
    with GeneratorWithDeclarations {
  void addProperty(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.Properties);
  }
}

abstract class GeneratorWithStaticConstants extends Object
    with GeneratorWithDeclarations {
  void addStaticConstant(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.StaticConstants);
  }
}

abstract class GeneratorWithStaticMethods extends Object
    with GeneratorWithDeclarations {
  void addStaticMethod(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.StaticMethods);
  }
}

abstract class GeneratorWithStaticProperties extends Object
    with GeneratorWithDeclarations {
  void addStaticProperty(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.StaticProperties);
  }
}

abstract class GeneratorWithStaticVariables extends Object
    with GeneratorWithDeclarations {
  void addStaticVariable(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.StaticVariables);
  }
}

abstract class GeneratorWithTopLevelConstants extends Object
    with GeneratorWithDeclarations {
  void addTopLevelConstant(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.TopLevelConstants);
  }
}

abstract class GeneratorWithTopLevelMethods extends Object
    with GeneratorWithDeclarations {
  void addTopLevelMethod(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.TopLevelMethods);
  }
}

abstract class GeneratorWithTopLevelProperties extends Object
    with GeneratorWithDeclarations {
  void addTopLevelProperty(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.TopLevelProperties);
  }
}

abstract class GeneratorWithTopLevelVariables extends Object
    with GeneratorWithDeclarations {
  void addTopLevelVariable(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.TopLevelVariables);
  }
}

abstract class GeneratorWithTypedefs extends Object
    with GeneratorWithDeclarations {
  void addTypedef(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.Typedefs);
  }
}

abstract class GeneratorWithVariables extends Object
    with GeneratorWithDeclarations {
  void addVariable(DeclarationGenerator declaration) {
    if (declaration == null) {
      throw new ArgumentError.notNull("declaration");
    }

    addDeclaration(declaration, DeclarationKey.Variables);
  }
}
