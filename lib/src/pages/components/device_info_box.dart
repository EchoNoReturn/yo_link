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
        Text(AppLocalizations.of(context)!.deviceIpInfo(widget.data.ip)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.deviceName(widget.data.name)),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                icon: Icon(Icons.copy),
                padding: const EdgeInsets.all(0.0),
                alignment: Alignment.center,
                iconSize: 14.0,
                onPressed: () {
                  widget.data.copy();
                },
              ),
            )
          ],
        ),
      ],
    ));
  }
}
