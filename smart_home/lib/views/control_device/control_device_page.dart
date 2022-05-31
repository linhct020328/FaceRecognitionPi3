import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:smarthome/bloc/vosk_bloc/vosk_bloc.dart';
import 'package:smarthome/model/device.dart';
import 'package:smarthome/provider/mqtt/mqtt_service.dart';
import 'package:smarthome/views/control_device/widgets/settings_dialog.dart';
import 'package:smarthome/views/widgets/widgets/exit_dialog.dart';
import 'widgets/button_group_widget.dart';
import 'widgets/voice_state_widget.dart';

class ControlDevicePage extends StatefulWidget {
  const ControlDevicePage({Key key, this.device}) : super(key: key);

  final Device device;

  @override
  _ControlDevicePageState createState() => _ControlDevicePageState();
}

class _ControlDevicePageState extends State<ControlDevicePage> {
  MQTTService manager;

  bool _isLoading = true;
  bool _isError = false;

  Future _configureAndConnect() async {
    try {
      manager = MQTTService(
          host: widget.device.mqttBroker,
          port: widget.device.port,
          topic: widget.device.topic,
          username: widget.device.userName,
          password: widget.device.password,
          clientId: widget.device.clientID);
      await manager.initMQTT();
      await manager.connectMQTT();
      setState(() {
        _isLoading = false;
        _isError = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _configureAndConnect();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _loading();
    }

    if (_isError) {
      return _error();
    }

    return MultiBlocProvider(
        providers: [
          BlocProvider<VoskBloc>.value(
              value: BlocProvider.of<VoskBloc>(context)..add(StartVoskEvent())),
        ],
        child: _ControlDevicePage(
          device: widget.device,
          mqttService:  manager,
        ));
  }

  Widget _loading() {
    return Scaffold(
      appBar: AppBar(
          title:
              Text('MQTT: ${widget.device.mqttBroker}:${widget.device.port}')),
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _error() {
    return Scaffold(
      appBar: AppBar(
          title:
              Text('MQTT: ${widget.device.mqttBroker}:${widget.device.port}')),
      body: SafeArea(
        child: Center(
          child: Text('Đã xảy ra lỗi'),
        ),
      ),
    );
  }
}

class _ControlDevicePage extends StatelessWidget {
  _ControlDevicePage({Key key, this.device, this.mqttService}) : super(key: key);

  final Device device;
  final MQTTService mqttService;
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
                              ListTile(
                                title: Text('Điều khiển'),
                              ),
                              ListTile(
                                title: Text('Hình ảnh chưa xác định'),
                              ),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // MyPhoneListenerWidget(),
                ButtonGroupWidget(mqttService),
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
