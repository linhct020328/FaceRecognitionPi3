import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:smarthome/bloc/vosk_bloc/vosk_bloc.dart';
import 'package:smarthome/model/device.dart';
import 'package:smarthome/views/control_device/widgets/settings_dialog.dart';
import 'package:smarthome/views/widgets/widgets/exit_dialog.dart';

import '../../get_it.dart';
import 'bloc/control_device_bloc.dart';
import 'widgets/button_group_widget.dart';
import 'widgets/voice_state_widget.dart';

class ControlDevicePage extends StatelessWidget {
  const ControlDevicePage({Key key, this.device}) : super(key: key);

  final Device device;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<VoskBloc>.value(
              value: BlocProvider.of<VoskBloc>(context)..add(StartVoskEvent())),
          BlocProvider(
            create: (_) => locator<ControlDeviceBloc>(),
          )
        ],
        child: _ControlDevicePage(
          device: device,
        ));
  }
}

class _ControlDevicePage extends StatelessWidget {
  _ControlDevicePage({Key key, this.device}) : super(key: key);

  final Device device;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => ExitAlertDialog(),
      ),
      child: Scaffold(
          appBar: AppBar(
            title: Text('MQTT: ${device.mqttBroker}:${device.port}'),
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(title: Text('Điều khiển'),),
                          ListTile(title: Text('Hình ảnh chưa xác định'),),
                        ],
                      ),
                    )),
              )
            ],
          ),
          key: scaffoldKey,
          body: _bodyWidget(context)),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    final sc = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: IconButton(
            //     icon: Icon(
            //       Icons.settings,
            //       size: 36,
            //       color: Colors.black,
            //     ),
            //     onPressed: () => _settings(context),
            //   ),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: sc.height / 2, child: MyPhoneListenerWidget()),
                SizedBox(
                    height: ScreenUtil().setHeight(250),
                    child: ButtonGroupWidget()),
                SizedBox(
                  height: ScreenUtil().setHeight(52),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _settings(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (context) =>
            BlocBuilder<VoskBloc, VoskState>(builder: (context, state) {
              if (state is VoskInited) {
                return SettingsDialog(true);
              } else if (state is VoskStopped) {
                return SettingsDialog(false);
              } else if (state is VoskError) {
                return SettingsDialog(null);
              }

              return Loading(
                  indicator: BallPulseIndicator(),
                  size: ScreenUtil().setWidth(50),
                  color: Colors.blue);
            }));
  }
}
