import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String appVersion(String version) {
    return 'App Version: $version';
  }

  @override
  String deviceIpInfo(String ip) {
    return 'Device Ip: $ip';
  }

  @override
  String deviceName(String name) {
    return 'Device Name: $name';
  }

  @override
  String shareDevice(int number) {
    return 'Share To: $number';
  }

  @override
  String get modeInfo => 'Mode:';

  @override
  String get github => 'Github';

  @override
  String get wechat => 'WeChat';

  @override
  String get qq => 'QQ';

  @override
  String get document => 'Help Document';

  @override
  String get copy => 'Click to copy information';
}
