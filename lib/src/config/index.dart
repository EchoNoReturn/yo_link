class AppConfig {
  // 窗口配置
  static const windowConfig = WindowConfig(
    width: 320,
    height: 568,
    title: 'My first flutter application',
  );

  // 数据库配置
  static const dbConfig = DatabaseConfig(
    host: 'localhost',
    port: 5432,
    name: 'my_app_db'
  );
}

class WindowConfig {
  final double width;
  final double height;
  final String title;

  const WindowConfig({
    required this.width,
    required this.height,
    required this.title,
  });
}

class DatabaseConfig {
  final String host;
  final int port;
  final String name;

  const DatabaseConfig({
    required this.host,
    required this.port,
    required this.name,
  });
}
