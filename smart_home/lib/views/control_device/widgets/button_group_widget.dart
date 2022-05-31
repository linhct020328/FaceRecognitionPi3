import 'package:flutter/material.dart';
import 'package:smarthome/configs/values/colors.dart';
import 'package:smarthome/provider/mqtt/mqtt_service.dart';

class ButtonGroupWidget extends StatefulWidget {
  final MQTTService mqttService;

  ButtonGroupWidget(this.mqttService);

  @override
  _ButtonGroupWidgetState createState() => _ButtonGroupWidgetState();
}

class _ButtonGroupWidgetState extends State<ButtonGroupWidget> {
  bool _isOn = true;

  void _remote(String command) {
    widget.mqttService.sendMessage(command);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _remote('open'),
            child: CircleAvatar(
              backgroundColor: _isOn ? primary : Colors.grey,
              radius: 40,
              child: Icon(
                Icons.lock_open,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _remote('close'),
            child: CircleAvatar(
              backgroundColor: _isOn ? Colors.red : Colors.grey,
              radius: 40,
              child: Icon(
                Icons.lock,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
