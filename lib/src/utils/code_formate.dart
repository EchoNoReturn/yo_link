
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:yo_link/src/utils/logger.dart';

Map<String, dynamic> decodeMessage(Uint8List data) {
  try {
    final jsonStr = utf8.decode(data.toList());
    final Map<String, dynamic> message = json.decode(jsonStr);
    return message;
  } catch (e) {
    logger.e('解码消息错误: $e');
    return {};
  }
}

Uint8List encodeMessage(Map<String, dynamic> message) {
  final jsonStr = json.encode(message);
  return utf8.encode(jsonStr);
}