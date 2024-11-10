import 'package:flutter/material.dart';
import 'package:yo_link/src/utils/logger.dart';

class OpenBtn extends StatefulWidget {

  OpenBtn({super.key});
  @override
  State<StatefulWidget> createState() => _OpenBtnState();
}

class _OpenBtnState extends State<OpenBtn> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 150),
          maximumSize: Size(200, 200),
          shape: CircleBorder(),
          backgroundColor: open ? Colors.blueAccent[200] : Colors.white,
        ),
        onPressed: () {
          logger.d('open $open');
          setState(() {
            open = !open;
          });
        },
        child: Icon(Icons.power_settings_new_rounded, size: 60, color: open? Colors.white : Colors.red[300]),
      ),
    );
  }
}
