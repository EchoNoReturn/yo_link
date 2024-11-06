import 'package:flutter/material.dart';
import 'package:yo_link/src/entitis/device_info.dart';
import 'package:yo_link/src/utils/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  bool isOpen = false;
  bool showHelp = false;
  var number = 0;

  var deviceInfo = DeviceInfo(ip: '', name: '');

  void _handleClick(BuildContext context) {
    // Navigator.pushNamed(context, '/');
    setState(() {
      number++;
      deviceInfo.fix(newName: 'you is a pig', newIp: '192.168.0.37');
    });
    logger.d('number: $number');
    deviceInfo.copy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        shape: LinearBorder(side: BorderSide(width: 0.1), bottom: LinearBorderEdge(size: 1.0)),
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
              spacing: 10,
              children: [
                Text(
                  '设备名称${deviceInfo.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(backgroundColor: Colors.amber),
                ),
                Text('开启按钮'),
                Text('设备ip${deviceInfo.ip}'),
                Text('wifi 和 共享设备的按钮'),
              ],
            ),
          )),
    );
  }
}
