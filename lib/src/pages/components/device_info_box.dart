import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yo_link/l10n/gen/app_localizations.dart';
import 'package:yo_link/src/entitis/device_info.dart';

class DeviceInfoBox extends StatefulWidget {
  final DeviceInfo data;

  const DeviceInfoBox({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _DeviceInfoBoxState();
}

class _DeviceInfoBoxState extends State<DeviceInfoBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Text(
          widget.data.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(widget.data.ip),
        TextButton.icon(
          icon: Icon(Icons.copy, size: 13,),
          label: Text(AppLocalizations.of(context)!.copy),
          onPressed: () {
            widget.data.copy();
          },
        )
      ],
    ));
  }
}
