import 'package:flutter/material.dart';
import 'package:yo_link/src/entitis/device_info.dart';
import 'package:yo_link/src/utils/logger.dart';

class LinkConfigPage extends StatefulWidget {
  const LinkConfigPage({super.key});

  @override
  State<LinkConfigPage> createState() => _LinkConfigPageState();
}

class _LinkConfigPageState extends State<LinkConfigPage> {
  // 存储九宫格设备列表
  List<DeviceInfo?> devices = List.filled(9, null);
  
  @override
  void initState() {
    super.initState();
    // 设置当前设备，并标记为当前设备
    devices[4] = DeviceInfo(
      ip: '192.168.1.1', 
      name: '当前设备',
      isCurrentDevice: true, // 标记为当前设备
    );
  }

  // 显示设备信息编辑弹窗
  void _showDeviceEditDialog(int position) {
    final device = devices[position]!;
    if (device.isCurrentDevice) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('当前设备信息不可修改')),
      );
      return;
    }

    final ipController = TextEditingController(text: device.ip);
    final nameController = TextEditingController(text: device.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('修改设备信息'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ipController,
              decoration: InputDecoration(
                labelText: 'IP地址',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '设备名称',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                devices[position] = DeviceInfo(
                  ip: ipController.text,
                  name: nameController.text,
                  isCurrentDevice: false,
                );
              });
              Navigator.pop(context);
            },
            child: Text('确认'),
          ),
        ],
      ),
    );
  }

  // 显示新增设备弹窗
  void _showAddDeviceDialog(int position) {
    final ipController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('新增设备'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ipController,
              decoration: InputDecoration(
                labelText: 'IP地址',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '设备名称',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                devices[position] = DeviceInfo(
                  ip: ipController.text,
                  name: nameController.text,
                  isCurrentDevice: false, // 新增设备默认非当前设备
                );
              });
              Navigator.pop(context);
            },
            child: Text('确认'),
          ),
        ],
      ),
    );
  }

  // 构建单个格子
  Widget _buildGridItem(int index) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        final draggedIndex = details.data;
        final draggedDevice = devices[draggedIndex];
        final targetDevice = devices[index];
        
        // 如果任一设备是当前设备，则不允许修改
        if (draggedDevice?.isCurrentDevice == true || 
            targetDevice?.isCurrentDevice == true) {
          return;
        }
        
        setState(() {
          final temp = devices[draggedIndex];
          devices[draggedIndex] = devices[index];
          devices[index] = temp;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return devices[index] == null
            ? InkWell(
                onTap: () => _showAddDeviceDialog(index),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add, size: 30),
                ),
              )
            : InkWell( // 添加点击事件
                onTap: () => _showDeviceEditDialog(index),
                child: Draggable<int>(
                  data: index,
                  feedback: Material(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(devices[index]!.name),
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: devices[index]!.isCurrentDevice 
                          ? Colors.blue[100] 
                          : Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                devices[index]!.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                devices[index]!.ip,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (devices[index]!.isCurrentDevice)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.orange,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  // 构建删除区域
  Widget _buildDeleteZone() {
    return DragTarget<int>(
      onWillAcceptWithDetails: (data) {
        // 检查是否为当前设备
        return devices[data.data]?.isCurrentDevice == false;
      },
      onAcceptWithDetails: (details) {
        setState(() {
          devices[details.data] = null;
        });
      },
      builder: (context, candidateData, rejectedData) {
        final isActive = candidateData.isNotEmpty;
        return Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isActive ? Colors.red : Colors.red[100]!,
              width: isActive ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isActive ? Colors.red.withOpacity(0.1) : Colors.grey[100]!,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_outline,
                color: isActive ? Colors.red : Colors.redAccent[100]!,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                '拖拽至此处删除设备',
                style: TextStyle(
                  color: isActive ? Colors.red : Colors.redAccent[100]!,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );

  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(66.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: AppBar(
            title: const Text('链接配置'),
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            toolbarHeight: 50.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 9,
                itemBuilder: (context, index) => _buildGridItem(index),
              ),
            ),
          ),
          _buildDeleteZone(), // 添加删除区域
          // SizedBox(height: 16), // 添加间距
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                    minimumSize: Size(100, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('取消'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    logger.d('保存设备配置: $devices');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    minimumSize: Size(100, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('保存'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 