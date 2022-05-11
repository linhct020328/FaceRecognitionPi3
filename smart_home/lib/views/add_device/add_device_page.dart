import 'package:flutter/material.dart';
import 'package:smarthome/model/device.dart';

import 'add_device_form.dart';

class AddDevicePage extends StatelessWidget {
  const AddDevicePage({Key key, this.devices = const []}) : super(key: key);

  final List<Device> devices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm thiết bị'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AddDeviceForm(devices: devices,),
      ),
    );
  }
}
