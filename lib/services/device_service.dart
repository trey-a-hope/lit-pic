import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'dart:io';

abstract class DeviceService {
  Future<String> getDeviceID();
  Future<String> getAppVersionNumber();
  Future<String> getAppBuildNumber();
}

class DeviceServiceImplementation extends DeviceService {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  Future<String> getDeviceID() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.androidId;
    }
  }

  @override
  Future<String> getAppVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Future<String> getAppBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }
}
