import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:yo_link/src/utils/logger.dart';

Future<String> getDeviceName() async {
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var deviceName = '--';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macosInfo = await deviceInfo.macOsInfo;
      deviceName = macosInfo.computerName;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      deviceName = linuxInfo.prettyName;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      deviceName = windowsInfo.computerName;
    } else {
      deviceName = '--';
    }
    return deviceName;
  } catch (e) {
    logger.e(e);
    return '--';
  }
}

Future<String> getIpAddress() async {
  try {
    List<NetworkInterface> interfaces = await NetworkInterface.list();
    for (NetworkInterface interface in interfaces) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          return addr.address;
        }
      }
    }
    return '--';
  } catch (e) {
    logger.e(e);
    return '--';
  }
}
