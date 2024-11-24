// 消息数据结构
import 'package:flutter/services.dart';
import 'package:yo_link/src/utils/code_formate.dart';
import 'package:yo_link/src/utils/logger.dart';

class YoMessage<T> {
  final String namespace;
  final String event;
  final T data;
  final int timestamp;

  YoMessage(this.namespace, this.event, this.data, this.timestamp);

  // 添加一个工厂构造函数来进行类型推导
  factory YoMessage.from(String namespace, String event, T data) {
    return YoMessage<T>(
        namespace, event, data, DateTime.now().millisecondsSinceEpoch);
  }

  factory YoMessage.fromUint8List(Uint8List data) {
    try {
      final message = decodeMessage(data);
      String? namespace = message['namespace'];
      String? event = message['event'];
      dynamic dataInfo = message['data'];
      return YoMessage.from(namespace ?? '', event ?? '', dataInfo);
    } catch (e) {
      logger.e('解码消息错误: $e');
      dynamic dataInfo;
      return YoMessage.from('', '', dataInfo);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'namespace': namespace,
      'event': event,
      'data': data,
      'timestamp': timestamp,
    };
  }

  Uint8List toUint8List() {
    return encodeMessage(toMap());
  }
}
