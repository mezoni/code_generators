part of code_generators;

abstract class DirectiveGenerator implements Generator {
  String get key;
}

abstract class ImportDirective implements DirectiveGenerator {
  List<String> _hide;

  bool _isDeferred;

  String _key;

  String _prefix;

  List<String> _show;

  List<String> _uri;

  ImportDirective(List<String> uri,
      {List<String> hide,
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

class LibraryDirective implements DirectiveGenerator {
  String _name;

  LibraryDirective(String name) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    _name = name;
  }

  String get key {
    return _name;
  }

  List<String> generate() {
    var sb = new StringBuffer();
    sb.write("library ");
    sb.write(_name);
    sb.write(";");
    return <String>[sb.toString()];
  }
}

class PartDirective implements DirectiveGenerator {
  String _uri;

  PartDirective(String uri) {
    if (uri == null) {
      throw new ArgumentError.notNull("uri");
    }

    _uri = uri;
  }

  String get key {
    return _uri;
  }

  List<String> generate() {
    var sb = new StringBuffer();
    sb.write("part '");
    sb.write(_uri);
    sb.write("';");
    return <String>[sb.toString()];
  }
}

class PartOfDirective implements DirectiveGenerator {
  String _name;

  PartOfDirective(String name) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    _name = name;
  }

  String get key {
    return _name;
  }

  List<String> generate() {
    var sb = new StringBuffer();
    sb.write("part of ");
    sb.write(_name);
    sb.write(";");
    return <String>[sb.toString()];
  }
}
