import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:yo_link/src/entitis/message.dart';
import 'package:yo_link/src/utils/logger.dart';

class YoServer {
  ServerSocket? _serverSocket;
  final List<Socket> _connectedClients = [];

  // 心跳检测定时器
  Timer? _heartbeatTimer; 

  List<Socket> get connectedClients => _connectedClients;
  static final Uint8List _heartbeatMessage = Uint8List.fromList([0x01]); 

  // 事件处理器映射表 {namespace: {eventName: handlers[]}}
  final Map<String, Map<String, List<Function(dynamic data)>>> _eventHandlers = {};
  
  // 注册事件处理器
  void on(String namespace, String eventName, Function(dynamic data) handler) {
    _eventHandlers.putIfAbsent(namespace, () => {});
    _eventHandlers[namespace]!.putIfAbsent(eventName, () => []);
    _eventHandlers[namespace]![eventName]!.add(handler);
  }

  // 移除事件处理器
  void off(String namespace, String eventName, [Function(dynamic data)? handler]) {
    if (handler != null) {
      _eventHandlers[namespace]?[eventName]?.remove(handler);
    } else {
      _eventHandlers[namespace]?.remove(eventName);
    }
  }

  start(int port) async {
    try {
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      logger.i('服务启动成功 YoServer: start success');
      _serverSocket!.listen(
        (Socket clientSocket) {
          logger.i(
              '新客户端连接: ${clientSocket.remoteAddress.address}:${clientSocket.remotePort}');
          _connectedClients.add(clientSocket);
          _handleClientData(clientSocket);
          startHeartbeat(clientSocket);
        },
        onError: (error) {
          logger.i('服务错误: $error');
        },
        onDone: () {
          logger.i('服务关闭');
        },
      );
    } catch (e) {
      logger.e('服务启动异常 YoServer: start error: $e');
    }
  }

  _handleClientData(Socket clientSocket) {
    clientSocket.listen(
      (Uint8List data) {
        try {
          // 解析收到的数据
          final message = _decodeMessage(data);
          if (message != null) {
            final handlers = _eventHandlers[message.namespace]?[message.event];
            if (handlers != null) {
              for (var handler in handlers) {
                handler(message.data);
              }
            }
          }
        } catch (e) {
          logger.e('处理数据错误: $e');
        }
      },
      onDone: () {
        logger.i(
            '客户端断开连接: ${clientSocket.remoteAddress}:${clientSocket.remotePort}');
        // 客户端断开连接时，从连接列表中移除
        _connectedClients.remove(clientSocket);
        clientSocket.close();
      },
      onError: (error) {
        logger.i(
            '客户端错误: ${clientSocket.remoteAddress}:${clientSocket.remotePort}');
        _connectedClients.remove(clientSocket);
        clientSocket.close();
      },
    );
  }

  startHeartbeat(Socket clientSocket) {
    _heartbeatTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      try {
        clientSocket.write(_heartbeatMessage);
      } catch (e) {
        logger.e('发送心跳错误: $e');
        _connectedClients.remove(clientSocket);
        clientSocket.close();
        if (_heartbeatTimer != null) {
          _heartbeatTimer!.cancel();
        }
      }
    });
  }

  void stopServer() {
    _serverSocket?.close();
    for (var clientSocket in _connectedClients) {
      clientSocket.close();
    }
    _connectedClients.clear();
  }

  // 发送消息到客户端
  void emit(Socket clientSocket, String namespace, String event, dynamic data) {
    try {
      final message = _encodeMessage(namespace, event, data);
      clientSocket.write(message);
    } catch (e) {
      logger.e('发送数据错误: $e');
    }
  }

  // 广播消息到所有客户端
  void broadcast(String namespace, String event, dynamic data) {
    for (var client in _connectedClients) {
      emit(client, namespace, event, data);
    }
  }

  // 消息编码
  Uint8List _encodeMessage(String namespace, String event, dynamic data) {
    final message = {
      'namespace': namespace,
      'event': event,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    return Uint8List.fromList(json.encode(message).codeUnits);
  }

  // 消息解码
  YoMessage? _decodeMessage(Uint8List data) {
    try {
      final jsonStr = String.fromCharCodes(data);
      final Map<String, dynamic> message = json.decode(jsonStr);
      return YoMessage(
        message['namespace'] as String,
        message['event'] as String,
        message['data'],
      );
    } catch (e) {
      logger.e('解码消息错误: $e');
      return null;
    }
  }
}
