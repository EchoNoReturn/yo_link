import 'package:clipboard/clipboard.dart';
import '../utils/logger.dart';

class DeviceInfo {
  String _ip = '';
  String _name = '';
  bool _isCurrentDevice = false;

  // 让 ip 和 name 只读
  String get ip {
    return _ip;
  }

  String get name {
    return _name;
  }

  bool get isCurrentDevice {
    return _isCurrentDevice;
  }

  DeviceInfo({
    required String ip,
    required String name,
    bool isCurrentDevice = false,
  }) : _name = name, _ip = ip, _isCurrentDevice = isCurrentDevice;

  /// 修改ip
  void fixIp(String newIp) {
    logger.i("DeviceInfo: Fix IP '$_ip' to '$newIp'");
    _ip = newIp;
  }

  /// 修改设备名称
  void fixName(String newName) {
    logger.i("DeviceInfo: Fix name '$_name' to '$newName'");
    _name = newName;
  }

  /// 同时修改设备名称和ip
  void fix({
    required String newName,
    required String newIp,
  }) {
    fixIp(newIp);
    fixName(newName);
  }

  /// 复制设备信息到剪贴板
  Future<bool> copy() async {
    try {
      // 复制内容到剪贴板
      await FlutterClipboard.copy('DeviceIP: $_ip ;DeviceName: $_name');
      return true;
    } catch (e) {
      logger.e("DeviceInfo", error: e);
      return false;
    }
  }
}
