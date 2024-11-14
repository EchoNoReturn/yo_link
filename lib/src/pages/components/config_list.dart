import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yo_link/src/entitis/list_item_data.dart';

class ConfigList extends StatelessWidget {
  final List<ListItemData> data;

  const ConfigList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: data
          .map<Widget>((item) => ListTile(
                title: Text(item.title),
                subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
                leading: item.prefix,
                trailing: item.suffix,
                onTap: item.onTap,
              ))
          .toList(),
    );
  }
}
