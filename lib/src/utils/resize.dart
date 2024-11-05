import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yo_link/src/config/index.dart';

/// 设置窗口为固定大小
Future<void> configWindowsSize() async {
  if (!isPc()) return;
  // 针对PC端
  await windowManager.ensureInitialized();

  final screenSize =
      Size(AppConfig.windowConfig.width, AppConfig.windowConfig.height);

  WindowOptions windowOptions = WindowOptions(
    size: screenSize,
    minimumSize: screenSize,
    maximumSize: screenSize,
    center: false,
    title: AppConfig.windowConfig.title,
    // titleBarStyle: TitleBarStyle.hidden, // 隐藏标题栏
    // windowButtonVisibility: false, // 隐藏窗口按钮
    // backgroundColor: Colors.transparent,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

/// 判断是否是PC端
bool isPc() {
  return !!(Platform.isWindows || Platform.isLinux || Platform.isMacOS);
}
