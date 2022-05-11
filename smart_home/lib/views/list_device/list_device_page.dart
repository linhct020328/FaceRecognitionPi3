import 'package:flutter/material.dart';
import 'package:smarthome/model/device.dart';
import 'package:smarthome/views/add_device/add_device_page.dart';
import 'package:smarthome/views/control_device/control_device_page.dart';

class ListDevicePage extends StatefulWidget {
  const ListDevicePage({Key key, this.devices}) : super(key: key);

  final List<Device> devices;

  @override
  _ListDevicePageState createState() => _ListDevicePageState();
}

class _ListDevicePageState extends State<ListDevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thiết bị'),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final device = widget.devices[index];

            return ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ControlDevicePage(
                            device: device,
                          ))),
              title: Text('${device.mqttBroker}:${device.port}'),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: widget.devices.length),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddDevicePage(
                      devices: widget.devices,
                    ))),
      ),
    );
  }
}
