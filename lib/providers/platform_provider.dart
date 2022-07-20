import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class PlatformProvider extends ChangeNotifier {

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;



  Future<bool> isAndroid11() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    if (isAndroid) {
      return androidDeviceInfo.version.release! == '11';
    } else {
      return false;
    }
  }
}
