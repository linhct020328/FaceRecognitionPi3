import 'package:flutter/material.dart';
import 'package:smarthome/model/device.dart';
import 'package:smarthome/provider/helpers/local_notify/local_notify_helper.dart';
import 'package:smarthome/provider/local/local_provider.dart';
import 'package:smarthome/provider/local/local_setting_pref.dart';
import 'package:smarthome/views/list_device/list_device_page.dart';

import '../../get_it.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = true;

  Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    debugPrint('_onDidReceiveLocalNotification payload: ' + payload);
  }

  Future _selectNotification(String payload) async {
    debugPrint('selectNotification payload: ' + payload);
  }

  Future _onLaunchAppByNotification(String payload) async {
    debugPrint('onLaunchAppByNotification payload: ' + payload);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (LocalSettingsPref.isFirstNotifySetting()) {
        await locator<LocalNotifyHelper>().initLocalNotification(
            onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
            selectNotification: _selectNotification,
            onLaunchAppByNotification: _onLaunchAppByNotification);
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder<List<Device>>(
              future: locator<LocalProvider>().getDevices(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Device>> snapshot) {
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
