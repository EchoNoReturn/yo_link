import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yo_link/src/utils/logger.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});
  @override
  State<StatefulWidget> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  late SharedPreferences prefs;
  // 添加状态变量
  bool clipboardEnabled = true;
  bool fileDragEnabled = true;
  String fileDropPath = '/Downloads';
  String fileOpenStrategy = '提示并打开';
  double maxClipboardSize = 10; // MB为单位

  @override
  void initState() {
    super.initState();
    loadConfigs();
  }
  Future<void> loadConfigs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      clipboardEnabled = prefs.getBool('clipboardEnabled') ?? true;
      fileDragEnabled = prefs.getBool('fileDragEnabled') ?? true;
      fileDropPath = prefs.getString('fileDropPath') ?? '/Downloads';
      fileOpenStrategy = prefs.getString('fileOpenStrategy') ?? '提示并打开';
      maxClipboardSize = prefs.getDouble('maxClipboardSize') ?? 10.0;
    });
  }

  Future<void> saveConfigs() async {
    await prefs.setBool('clipboardEnabled', clipboardEnabled);
    await prefs.setBool('fileDragEnabled', fileDragEnabled);
    await prefs.setString('fileDropPath', fileDropPath);
    await prefs.setString('fileOpenStrategy', fileOpenStrategy);
    await prefs.setDouble('maxClipboardSize', maxClipboardSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(66.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: AppBar(
            title: const Text('配置'),
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            toolbarHeight: 50.0,
            // foregroundColor: Colors.white,
          ),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              _buildSectionHeader("常规设置"),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('剪贴板共享'),
                subtitle: const Text('启用后可以在设备间共享剪贴板内容'),
                value: clipboardEnabled,
                onChanged: (bool value) async {
                  setState(() {
                    clipboardEnabled = value;
                  });
                  await saveConfigs();
                },
              ),
              const Divider(),
              
              _buildSectionHeader("文件传输"),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('文件拖拽传输'),
                subtitle: const Text('允许通过拖拽方式传输文件'),
                value: fileDragEnabled,
                onChanged: (bool value) {
                  setState(() {
                    fileDragEnabled = value;
                  });
                },
              ),
              ListTile(
                title: const Text('文件保存位置'),
                subtitle: Text(fileDropPath),
                trailing: const Icon(Icons.folder_open),
                onTap: () async {
                  logger.i('选择文件保存位置');
                },
              ),
              const Divider(),
              
              _buildSectionHeader("安全设置"),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('剪贴板大小限制'),
                subtitle: Text('${maxClipboardSize.toStringAsFixed(0)}MB'),
                trailing: SizedBox(
                  width: 200,
                  child: Slider(
                    value: maxClipboardSize,
                    min: 1,
                    max: 100,
                    divisions: 99,
                    label: '${maxClipboardSize.toStringAsFixed(0)}MB',
                    onChanged: (double value) async {
                      setState(() {
                        maxClipboardSize = value;
                      });
                      await saveConfigs();
                    },
                  ),
                ),
              ),
            ],
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => {
                      logger.d("cancel"),
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      backgroundColor: Colors.red[300],
                      foregroundColor: Colors.white,
                      minimumSize: Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                        child: Text('取消', style: TextStyle(fontSize: 16.0))),
                  )),
              ElevatedButton(
                onPressed: () => {
                  logger.d("save"),
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  minimumSize: Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    Center(child: Text('保存', style: TextStyle(fontSize: 16.0))),
              ),
            ],
          )
        ],
      )),
    );
  }

  // 添加一个辅助方法来创建统一的分组标题
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: Colors.grey[200],
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
