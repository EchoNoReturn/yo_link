import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yo_link/l10n/gen/app_localizations.dart';
import 'package:yo_link/src/entitis/device_info.dart';
import 'package:yo_link/src/entitis/help_link_info.dart';
import 'package:yo_link/src/pages/components/device_info_box.dart';
import 'package:yo_link/src/pages/components/open_btn.dart';
import 'package:yo_link/src/utils/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // 应用必备权限状态

  bool isOpen = false;
  bool showHelp = false;
  var number = 0;

  var deviceInfo = DeviceInfo(ip: '', name: '');

  @override
  void initState() {
    super.initState();
    _loadIpAddress();
  }

  void _loadIpAddress() async {
    final ip = await getIpAddress();
    setState(() {
      deviceInfo.fix(newName: deviceInfo.name, newIp: ip);
    });
  }

  void checkoutPermissions() async {
    /// WiFi 权限
    var wifiState = await Permission.nearbyWifiDevices.status;
    /// 蓝牙权限
    var bluetoothState = await Permission.bluetooth.status;
    logger.d('[权限检查结果] wifiState: $wifiState, bluetoothState: $bluetoothState');
    if (wifiState.isGranted) {
      logger.d('WiFi 权限已授权');
    } else {
      logger.d('WiFi 权限未授权, 开始申请');
      Permission.nearbyWifiDevices.request();
    }
  }

  void _checkWifiPermission() async {
    var wifiState = await Permission.nearbyWifiDevices.status;
    if (wifiState.isGranted) {
      logger.d('WiFi 权限已授权');
      // var snackBar = SnackBar(
      //   content: Text(AppLocalizations.of(context)!.wifiPermissionDenied),
      //   action: SnackBarAction(
      //     label: AppLocalizations.of(context)!.openSettings,
      //     onPressed: () {
      //       openAppSettings();
      //     },
      //   ),
      // );
    } else if (wifiState.isDenied) {
      logger.d('WiFi 权限未授权, 开始申请');
      Permission.nearbyWifiDevices.request();
    } else if (wifiState.isPermanentlyDenied) {
      logger.d('WiFi 权限被永久拒绝, 请手动开启');
    }
  }

  Future<String> getIpAddress() async {
    final info = NetworkInfo();
    final wifiIP = await info.getWifiIP();
    return wifiIP ?? 'Unknown';
  }

  void _handleClick(BuildContext context) {
    // Navigator.pushNamed(context, '/');
    setState(() {
      number++;
    });
    logger.d('number: $number');
    deviceInfo.copy();
  }

  @override
  Widget build(BuildContext context) {
    /// 使用默认浏览器打开链接
    Future<void> _launchUrl(String url) async {
      if (!await launchUrl(Uri.parse(url))) {
        logger.e('Could not launch $url');
      }
    }

    final List<HelpLinkInfo> helpLinks = [
      HelpLinkInfo(
          icon: Icon(Icons.wechat_rounded),
          url: "",
          desc: AppLocalizations.of(context)!.wechat),
      HelpLinkInfo(
          icon: Icon(Icons.document_scanner_outlined),
          url: "",
          desc: AppLocalizations.of(context)!.document),
      HelpLinkInfo(
          icon: Icon(MdiIcons.github),
          url: "",
          desc: AppLocalizations.of(context)!.github),
    ];
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 50,
        shape: LinearBorder(
            side: BorderSide(width: 0.1), bottom: LinearBorderEdge(size: 1.0)),
        title: Row(
          children: [
            // 设置按钮
            ElevatedButton(
              onPressed: () => _handleClick(context),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                fixedSize: Size(30, 30), // 设置相同的宽高
                minimumSize: Size(30, 30),
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                  child: Icon(Icons.settings, color: Colors.blueAccent[700])),
            ),
          ],
        ),
      ),
      body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DeviceInfoBox(
                  data: deviceInfo,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 0.0),
                  child: OpenBtn(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 两个按钮
                      ElevatedButton(
                        onPressed: () => _handleClick(context),
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor:
                              const Color.fromARGB(255, 152, 142, 246),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        child: Text(AppLocalizations.of(context)!.shareDevice(
                            1)), // Added the required 'child' parameter
                      ),
                      SizedBox(width: 16), // Add spacing between buttons
                      ElevatedButton(
                        onPressed: () => _handleClick(context),
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor:
                              const Color.fromARGB(255, 246, 163, 158),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.modeInfo),
                            Icon(Icons.wifi),
                          ],
                        ), // Added the required 'child' parameter
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
      floatingActionButton: PopupMenuButton(
        tooltip: 'Help & Resources',
        offset: Offset(0, 40),
        itemBuilder: (context) => helpLinks
            .map(
              (item) => PopupMenuItem(
                onTap: () {
                  logger.d('clicked item: ${item.desc}');
                  _launchUrl(item.url);
                },
                child: Row(
                  spacing: 10,
                  children: [
                    item.icon,
                    Text(item.desc),
                  ],
                ),
              ),
            )
            .toList(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Icon(Icons.help_outline_rounded, color: Colors.black87, size: 24),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}
