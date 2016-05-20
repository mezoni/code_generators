part of code_generators;

abstract class DirectiveGenerator implements Generator {
  String get key;
}

class ExportDirectiveGenerator implements DirectiveGenerator {
  Generator _comment;

  List<String> _hide;

  List<String> _metadata;

  List<String> _show;

  String _uri;

  ExportDirectiveGenerator(String uri,
      {Generator comment,
      List<String> hide,
      List<String> metadata,
      List<String> show}) {
    if (uri == null) {
      throw new ArgumentError.notNull("uri");
    }

    if (hide != null) {
      if (hide.length == 0) {
        throw new ArgumentError.value(hide, "hide", "Cannot not be empty");
      }
    }

    if (show != null) {
      if (show.length == 0) {
        throw new ArgumentError.value(show, "show", "Cannot not be empty");
      }
    }

    _comment = comment;
    _hide = hide?.toList();
    _show = show?.toList();
    _uri = uri;
  }

  String get key {
    return _uri;
  }

  List<String> generate() {
    var result = <String>[];
    if (_metadata != null) {
      var list = _metadata;
      list.sort((a, b) => a.compareTo(b));
      result.addAll(list);
    }

    if (_comment != null) {
      result.addAll(_comment.generate());
    }

    var sb = new StringBuffer();
    sb.write("export '");
    sb.write(_uri);
    sb.write("'");
    if (_show != null) {
      var list = _show.toList();
      list.sort((a, b) => a.compareTo(b));
      sb.write(" show ");
      sb.write(list.join(", "));
    }

    if (_hide != null) {
      var list = _hide.toList();
      list.sort((a, b) => a.compareTo(b));
      sb.write(" hide ");
      sb.write(list.join(", "));
    }

    sb.write(";");
    result.add(sb.toString());
    return result;
  }
}

class ImportDirectiveGenerator implements DirectiveGenerator {
  Generator _comment;

  List<String> _hide;

  bool _isDeferred;

  String _key;

  List<String> _metadata;

  String _prefix;

  List<String> _show;

  String _uri;

  ImportDirectiveGenerator(String uri,
      {Generator comment,
      List<String> hide,
      bool isDeferred: false,
      List<String> metadata,
      String prefix,
      List<String> show}) {
    if (uri == null) {
      throw new ArgumentError.notNull("uri");
    }

    if (isDeferred == null) {
      throw new ArgumentError.notNull("isDeferred");
    }

    if (isDeferred) {
      if (prefix == null) {
        throw new StateError("Deferred import should have a prefix");
      }
    }

    if (hide != null) {
      if (hide.length == 0) {
        throw new ArgumentError.value(hide, "hide", "Cannot not be empty");
      }
    }

    if (show != null) {
      if (show.length == 0) {
        throw new ArgumentError.value(show, "show", "Cannot not be empty");
      }
    }

    _comment = comment;
    _hide = hide?.toList();
    _isDeferred = isDeferred;
    _key = uri;
    _metadata = metadata;
    _prefix = prefix;
    _show = show?.toList();
    _uri = uri;
  }

  String get key {
    return _key;
  }

  List<String> generate() {
    var result = <String>[];
    if (_metadata != null) {
      var list = _metadata;
      list.sort((a, b) => a.compareTo(b));
      result.addAll(list);
    }

    if (_comment != null) {
      result.addAll(_comment.generate());
    }

    var sb = new StringBuffer();
    sb.write("import ");
    sb.write("'");
    sb.write(_uri);
    sb.write("'");
    if (_isDeferred) {
      sb.write(" deferred");
    }

    if (_prefix != null) {
      sb.write(" as ");
      sb.write(_prefix);
    }

    if (_show != null) {
      var list = _show.toList();
      list.sort((a, b) => a.compareTo(b));
      sb.write(" show ");
      sb.write(list.join(", "));
    }

    if (_hide != null) {
      var list = _hide.toList();
      list.sort((a, b) => a.compareTo(b));
      sb.write(" hide ");
      sb.write(list.join(", "));
    }

    sb.write(";");
    result.add(sb.toString());
    return result;
  }
}

class LibraryDirectiveGenerator implements DirectiveGenerator {
  Generator _comment;

  String _name;

  LibraryDirectiveGenerator(String name, {Generator comment}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    _comment = comment;
    _name = name;
  }

  String get key {
    return _name;
  }

  List<String> generate() {
    var result = <String>[];
    if (_comment != null) {
      result.addAll(_comment.generate());
    }

    var sb = new StringBuffer();
    sb.write("library ");
    sb.write(_name);
    sb.write(";");
    result.add(sb.toString());
    return result;
  }
}

class PartDirectiveGenerator implements DirectiveGenerator {
  Generator _comment;

  List<String> _metadata;

  String _uri;

  PartDirectiveGenerator(String uri,
      {Generator comment, List<String> metadata}) {
    if (uri == null) {
      throw new ArgumentError.notNull("uri");
    }

    _comment = comment;
    _uri = uri;
  }

  String get key {
    return _uri;
  }

  List<String> generate() {
    var result = <String>[];
    if (_metadata != null) {
      var list = _metadata;
      list.sort((a, b) => a.compareTo(b));
      result.addAll(list);
    }

    if (_comment != null) {
      result.addAll(_comment.generate());
    }

    var sb = new StringBuffer();
    sb.write("part '");
    sb.write(_uri);
    sb.write("';");
    result.add(sb.toString());
    return result;
  }
}

class PartOfDirectiveGenerator implements DirectiveGenerator {
  Generator _comment;

  String _name;

  PartOfDirectiveGenerator(String name, {Generator comment}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    _comment = comment;
    _name = name;
  }

  String get key {
    return _name;
  }

  List<String> generate() {
    var result = <String>[];
    if (_comment != null) {
      result.addAll(_comment.generate());
    }

    var sb = new StringBuffer();
    sb.write("part of ");
    sb.write(_name);
    sb.write(";");
    result.add(sb.toString());
    return result;
  }
}
