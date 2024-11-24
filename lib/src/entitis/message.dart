// 消息数据结构
class YoMessage {
  final String namespace;
  final String event;
  final dynamic data;

  YoMessage(this.namespace, this.event, this.data);
}
