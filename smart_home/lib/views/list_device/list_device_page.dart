import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smarthome/get_it.dart';
import 'package:smarthome/model/device.dart';
import 'package:smarthome/provider/helpers/local_notify/local_notify_helper.dart';
import 'package:smarthome/provider/helpers/local_notify/receive_notification_entity.dart';
import 'package:smarthome/provider/local/local_provider.dart';
import 'package:smarthome/views/add_device/add_device_page.dart';
import 'package:smarthome/views/control_device/control_device_page.dart';
import 'package:smarthome/views/widgets/dialogs/loading_dialog.dart';

class ListDevicePage extends StatefulWidget {
  const ListDevicePage({Key key, this.devices}) : super(key: key);

  final List<Device> devices;

  @override
  _ListDevicePageState createState() => _ListDevicePageState();
}

class _ListDevicePageState extends State<ListDevicePage> {
  List<Device> devices;

  void _showDeleteDialog(Device device) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Xóa thiết bị'),
              content: Text('Bạn muốn xóa thiết bị này?'),
              actions: [
                ElevatedButton(
                    onPressed: () => _deleteDevice(device), child: Text('Xóa')),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: Text('Hủy')),
              ],
            ));
  }

  void _deleteDevice(Device device) async {
    Navigator.pop(context);
    LoadingDialog.show(context);

    devices.remove(device);

    final rawData = List<String>.generate(
        devices.length, (index) => jsonEncode(devices[index].toJson()));
    await locator<LocalProvider>().saveData(LocalKeys.devices, rawData);
    LoadingDialog.hide(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    devices = widget.devices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thiết bị'),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final device = devices[index];

            return ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ControlDevicePage(
                            device: device,
                          ))),
              title: Text(
                '${device.mqttBroker}:${device.port}',
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => _showDeleteDialog(device),
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: devices.length),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddDevicePage(
                        devices: devices,
                      )));
          print('result: $result');
          if (result != null) setState(() {});
        },
      ),
    );
  }
}
