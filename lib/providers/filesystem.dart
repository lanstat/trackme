import 'dart:io';

import 'package:path_provider/path_provider.dart';

enum DirectoryType {
  cache,
  download,
  temp,
}

class FilesystemProvider {
  static final FilesystemProvider _instance = FilesystemProvider._();
  static FilesystemProvider get instance => _instance;
  FilesystemProvider._();

  Future<String> _getDir(DirectoryType type) async {
    switch (type) {
      case DirectoryType.cache:
        final dir = await getApplicationDocumentsDirectory();
        return dir.path;
      case DirectoryType.download:
        final dir = await getDownloadsDirectory();
        if (dir == null) {
          throw 'Invalid download directory';
        }
        return dir.path;
      case DirectoryType.temp:
        final dir = await getTemporaryDirectory();
        return dir.path;
    }
  }

  Future<File> writeFile(DirectoryType type, String filename, String raw) async {
    final path = await _getDir(type);
    final file = File('$path/$filename');
    await file.writeAsString(raw);
    return file;
  }

  Future<String> readFile(DirectoryType type, String filename) async {
    try {
      final path = await _getDir(type);
      final file = File('$path/$filename');
      return await file.readAsString();
    } catch(e) {
      return '';
    }
  }

  Future<File?> getFile(DirectoryType type, String filename) async {
    try {
      final path = await _getDir(type);
      return File('$path/$filename');
    } catch(e) {
      return null;
    }
  }
}
