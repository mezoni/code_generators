part of code_generators;

abstract class DirectiveGenerator implements Generator {
  String get key;
}

class ExportDirectiveGenerator implements DirectiveGenerator {
  Generator _comment;

  String _uri;

  ExportDirectiveGenerator(String uri,
      {Generator comment, List<String> hide, List<String> show}) {
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
    return result;
  }
}

class ImportDirectiveGenerator implements DirectiveGenerator {
  Generator _comment;

  List<String> _hide;

  bool _isDeferred;

  String _key;

  String _prefix;

  List<String> _show;

  List<String> _uri;

  ImportDirectiveGenerator(List<String> uri,
      {Generator comment,
      List<String> hide,
      bool isDeferred: false,
      String prefix,
      List<String> show}) {
    if (uri == null) {
      throw new ArgumentError.notNull("uri");
    }

    if (uri.length == 0) {
      throw new ArgumentError("List of uri should not be empty");
    }

    if (isDeferred == null) {
      throw new ArgumentError.notNull("isDeferred");
    }

    if (isDeferred) {
      if (_prefix == null) {
        throw new StateError("Deferred import should have a prefix");
      }
    }

    _comment = comment;
    _hide = hide?.toList();
    _isDeferred = isDeferred;
    _prefix = prefix;
    _show = show?.toList();
    _uri = uri.toList();
    _uri.sort((a, b) => a.compareTo(b));
    _key = _uri.join(" || ");
  }

  String get key {
    return _key;
  }

  List<String> generate() {
    var result = <String>[];
    var sb = new StringBuffer();
    sb.write("import ");
    var length = _uri.length;
    if (length == 1) {
      sb.write(_uri);
    } else {
      for (var i = 0; i < length; i++) {
        var uri = _uri[i];
        if (i > 0) {
          sb.write("      || ");
        }

        sb.write(uri);
        result.add(sb.toString());
        sb.clear();
      }

      sb.write("      ");
    }

    if (_prefix != null) {
      sb.write(" as ");
      sb.write(_prefix);
    }

    if (_isDeferred) {
      sb.write(" deferred");
    }

    if (_show != null) {
      _show.sort((a, b) => a.compareTo(b));
      sb.write(" show ");
      sb.write(_show.join(", "));
    }

    if (_hide != null) {
      _hide.sort((a, b) => a.compareTo(b));
      sb.write(" hide ");
      sb.write(_hide.join(", "));
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

  String _uri;

  PartDirectiveGenerator(String uri, {Generator comment}) {
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
