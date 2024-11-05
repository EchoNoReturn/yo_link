import 'package:flutter/material.dart';
import 'package:yo_link/src/pages/Home.dart';
import 'package:yo_link/src/utils/resize.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configWindowsSize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => HomePage(),
      },
      initialRoute: '/',
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => HomePage(), // 跳转错了就回到首页
      )
    );
  }
}
