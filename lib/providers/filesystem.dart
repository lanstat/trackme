import 'dart:io';

class FilesystemProvider {
  static final FilesystemProvider _instance = FilesystemProvider._();
  static FilesystemProvider get instance => _instance;
  FilesystemProvider._();

  Future<File> get _cacheDir async {
    return await getApplicationDocumentsDirectory();
  }

  Future<File> writeCacheFile(String filename, String raw) {

  }
}
