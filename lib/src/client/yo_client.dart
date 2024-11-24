import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:yo_link/src/entitis/message.dart';
import 'package:yo_link/src/utils/logger.dart';

class YoClient {
  Socket? _socket;
  bool _isConnected = false;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  final Map<String, Map<String, List<Function(dynamic data)>>> _eventHandlers =
      {};

  // 配置参数
  static const int _reconnectDelay = 3000;
  static const int _maxReconnectAttempts = 3;
  static const Duration _heartbeatInterval = Duration(seconds: 5);

  bool get isConnected => _isConnected;

  Future<void> connect(String host, int port) async {
    try {
      _socket = await Socket.connect(host, port);
      _isConnected = true;
      _reconnectAttempts = 0;
      _setupListeners();
      _startHeartbeat();
      logger.i('连接成功: $host:$port');
    } catch (e) {
      logger.e('连接失败: $e');
      _handleDisconnect();
    }
  }

  void _setupListeners() {
    _socket?.listen(
      (Uint8List data) {
        // 处理心跳消息
        if (data.length == 1 && data[0] == 0x01) {
          return;
        }

        try {
          final YoMessage messageMap = YoMessage.fromUint8List(data);
          if (messageMap.namespace.isNotEmpty && messageMap.event.isNotEmpty) return;
          final handlers =
              _eventHandlers[messageMap.namespace]?[messageMap.event];
          handlers?.forEach((handler) => handler(messageMap.data));
        } catch (e) {
          logger.e('数据处理错误: $e');
        }
      },
      onError: (error) {
        logger.e('连接错误: $error');
        _handleDisconnect();
      },
      onDone: () {
        logger.i('连接关闭');
        _handleDisconnect();
      },
    );
  }

  void _handleDisconnect() {
    _isConnected = false;
    _socket?.close();
    _heartbeatTimer?.cancel();

    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      _reconnectTimer = Timer(Duration(milliseconds: _reconnectDelay), () {
        connect(_socket!.remoteAddress.address, _socket!.remotePort);
      });
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      if (_isConnected) {
        emit('system', 'heartbeat', null);
      }
    });
  }

  void on(String namespace, String event, Function(dynamic data) handler) {
    _eventHandlers.putIfAbsent(namespace, () => {});
    _eventHandlers[namespace]!.putIfAbsent(event, () => []);
    _eventHandlers[namespace]![event]!.add(handler);
  }

  void off(String namespace, String event, [Function(dynamic data)? handler]) {
    if (handler != null) {
      _eventHandlers[namespace]?[event]?.remove(handler);
    } else {
      _eventHandlers[namespace]?.remove(event);
    }
  }

  void emit(String namespace, String event, dynamic data) {
    if (!_isConnected) return;

    try {
      final message = YoMessage.from(namespace, event, data).toUint8List();
      _socket?.add(message);
    } catch (e) {
      logger.e('发送消息错误: $e');
    }
  }

  void disconnect() {
    _isConnected = false;
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _socket?.close();
  }
}
