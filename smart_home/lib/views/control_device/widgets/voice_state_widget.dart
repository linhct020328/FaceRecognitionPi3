import 'package:avatar_glow/avatar_glow.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarthome/bloc/vosk_bloc/vosk_bloc.dart';
import 'package:smarthome/configs/constants/control_remote_constants.dart';
import 'package:smarthome/configs/constants/flare_constants.dart';
import 'package:smarthome/configs/constants/vosk_constants.dart';
import 'package:smarthome/provider/mqtt/mqtt_service.dart';
import 'package:smarthome/provider/voice_controller/voice_controller_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPhoneListenerWidget extends StatelessWidget {
  final MQTTService mqttService;

  MyPhoneListenerWidget(this.mqttService);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoskBloc, VoskState>(
      builder: (context, state) {
        if (state is VoskInited) {
          return VoiceContentWidget(true, mqttService);
        }
        return VoiceContentWidget(false, mqttService);
      },
    );
  }
}

class VoiceContentWidget extends StatefulWidget {
  final bool isEnable;
  final MQTTService mqttService;

  VoiceContentWidget(this.isEnable, this.mqttService);

  @override
  _VoiceContentWidgetState createState() => _VoiceContentWidgetState();
}

class _VoiceContentWidgetState extends State<VoiceContentWidget> {
  String text = "Nói 'Ok Sunday'";
  String keyFlare = FlareConstants.keyStand;
  bool isEnable = false;

  void _remoteDevice(String command) {
    widget.mqttService.sendMessage(command);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VoiceControllerProvider.wakeupStreamChannel
        .receiveBroadcastStream()
        .listen((data) {
      print(data);
      if (data.toString().contains("WAKEUP")) {
        setState(() {
          text = "Đang nghe...";
          keyFlare = FlareConstants.keyThink;
        });
      } else if (data.toString().contains("LISTENING")) {
        setState(() {
          text = "Nói '${VoskConstants.wakeup}'";
          keyFlare = FlareConstants.keyStand;
        });
      } else {
        final action = data.toString();
        setState(() {
          // Xét điều  khiển
          if (action.contains(VoskConstants.open)) {
            _remoteDevice(ControlRemoteConstants.open);
            text = VoskConstants.open;
          } else if (action.contains(VoskConstants.close)) {
            _remoteDevice(ControlRemoteConstants.close);
            text = VoskConstants.close;
          } else {
            //Hủy bỏ hành động
            if (action.contains(VoskConstants.cancel)) {
              text = "Hủy hành động";
            } else {
              text = "Tôi không hiểu";
            }
          }
          keyFlare = FlareConstants.keyOkay;
        });
      }
    }).onError((err) {
      setState(() {
        text = "Nhận diện giọng nói đã tắt";
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150.w,
          width: 150.w,
          child: FlareActor(FlareConstants.robotAssistant,
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: keyFlare),
        ),
        AvatarGlow(
          animate: widget.isEnable,
          glowColor: Colors.blue,
          endRadius: 45.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: Icon(
            Icons.mic,
            color: Colors.blue,
            size: 36,
          ),
        ),
        Visibility(
          visible: widget.isEnable,
          child: Text(
            text,
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle1
                .copyWith(color: Colors.black, fontSize: 20.sp),
          ),
        ),
        Visibility(
          visible: !widget.isEnable,
          child: Text(
            'Nhận diện giọng nói đã tắt',
            style: Theme.of(context)
                .primaryTextTheme
                .caption
                .copyWith(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
