import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smarthome/get_it.dart';
import 'package:smarthome/model/device.dart';
import 'package:smarthome/provider/local/local_provider.dart';
import 'package:smarthome/views/widgets/dialogs/loading_dialog.dart';

class AddDeviceForm extends StatefulWidget {
  const AddDeviceForm({Key key, this.devices = const []}) : super(key: key);

  final List<Device> devices;

  @override
  _AddDeviceFormState createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {
  final _mqttBrokerCtrl = TextEditingController();
  final _portCtrl = TextEditingController();
  final _clientIDCtrl = TextEditingController();
  final _userNameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _topicCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future _onSubmit() async {
    if (_formKey.currentState.validate()) {
      LoadingDialog.show(context);

      final newDevices = widget.devices;

      final device = Device(
        mqttBroker: _mqttBrokerCtrl.text.trim(),
        port: int.parse(_portCtrl.text.trim()),
        clientID: _clientIDCtrl.text.trim(),
        userName: _userNameCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        topic: _topicCtrl.text.trim(),
      );
      newDevices.insert(0, device);

      final rawData = List<String>.generate(newDevices.length,
          (index) => jsonEncode(newDevices[index].toJson()));
      await locator<LocalProvider>().saveData(LocalKeys.devices, rawData);
      _clear();
      LoadingDialog.hide(context);
      Navigator.pop(context, device);
    }
  }

  String _validator(String value) {
    if (value == null || value.isEmpty) return 'Trường bắt buộc.';

    return null;
  }

  void _clear(){
    _mqttBrokerCtrl.clear();
    _portCtrl.clear();
    _clientIDCtrl.clear();
    _userNameCtrl.clear();
    _passwordCtrl.clear();
    _topicCtrl.clear();
  }

  @override
  void dispose() {
    _mqttBrokerCtrl.dispose();
    _portCtrl.dispose();
    _clientIDCtrl.dispose();
    _userNameCtrl.dispose();
    _passwordCtrl.dispose();
    _topicCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _mqttBrokerCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'MQTT Broker', hintText: 'Eg: 192.168.1.1'),
            validator: _validator,
          ),
          TextFormField(
            controller: _portCtrl,
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(labelText: 'Port', hintText: 'Eg: 8080'),
            validator: _validator,
          ),
          TextFormField(
            controller: _clientIDCtrl,
            decoration: InputDecoration(
              labelText: 'Client ID',
            ),
            validator: _validator,
          ),
          TextFormField(
            controller: _userNameCtrl,
            decoration: InputDecoration(
              labelText: 'User name',
            ),
            validator: _validator,
          ),
          TextFormField(
            controller: _passwordCtrl,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            validator: _validator,
          ),
          TextFormField(
            controller: _topicCtrl,
            decoration: InputDecoration(
              labelText: 'Topic',
            ),
            validator: _validator,
          ),
          SizedBox(
            height: 24,
          ),
          SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                  onPressed: () async => await _onSubmit(), child: Text('Lưu')))
        ],
      ),
    );
  }
}
