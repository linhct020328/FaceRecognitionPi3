import 'package:flutter/material.dart';
import 'package:smarthome/model/device.dart';
import 'package:smarthome/provider/local/local_provider.dart';
import 'package:smarthome/views/list_device/list_device_page.dart';

import '../../get_it.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Device>>(
        future: locator<LocalProvider>().getDevices(),
        builder: (BuildContext context, AsyncSnapshot<List<Device>> snapshot) {
          if (snapshot.hasData) {

            return ListDevicePage(
              devices: snapshot.data,
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
