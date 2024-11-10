import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String appVersion(String version) {
    return '版本号：$version';
  }

  @override
  String deviceIpInfo(String ip) {
    return '设备IP: $ip';
  }

  @override
  String deviceName(String name) {
    return '设备名称: $name';
  }

  @override
  String shareDevice(int number) {
    return '共享: $number台';
  }

  @override
  String get modeInfo => '模式: ';

  @override
  String get github => 'Github';

  @override
  String get wechat => '微信公众号';

  @override
  String get qq => '腾讯QQ';

  @override
  String get document => '使用说明';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String appVersion(String version) {
    return '版本号：$version';
  }

  @override
  String deviceIpInfo(String ip) {
    return '设备IP: $ip';
  }

  @override
  String deviceName(String name) {
    return '设备名称: $name';
  }

  @override
  String shareDevice(int number) {
    return '共享: $number台';
  }

  @override
  String get modeInfo => '模式：';

  @override
  String get github => 'Github';

  @override
  String get wechat => '微信公众号';

  @override
  String get qq => '腾讯QQ';

  @override
  String get document => '使用说明';
}
