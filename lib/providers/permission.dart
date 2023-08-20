import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static final PermissionHandler _instance = PermissionHandler._();
  static PermissionHandler get instance => _instance;
  PermissionHandler._();

  Future<bool> requestStorage() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }
    status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    return false;
  }
}