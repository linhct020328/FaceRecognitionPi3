import 'package:avatar_glow/avatar_glow.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarthome/bloc/vosk_bloc/vosk_bloc.dart';
import 'package:smarthome/configs/constants/control_remote_constants.dart';
import 'package:smarthome/configs/constants/flare_constants.dart';
import 'package:smarthome/configs/constants/vosk_constants.dart';
import 'package:smarthome/model/remote_model.dart';
import 'package:smarthome/provider/voice_controller/voice_controller_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smarthome/views/control_device/bloc/control_device_bloc.dart';

class MyPhoneListenerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoskBloc, VoskState>(
      builder: (context, state) {
        if (state is VoskInited) {
          return VoiceContentWidget(true);
        }
        return VoiceContentWidget(false);
      },
    );
  }
}

class VoiceContentWidget extends StatefulWidget {
  final bool isEnable;

  VoiceContentWidget(this.isEnable);

  @override
  _VoiceContentWidgetState createState() => _VoiceContentWidgetState();
}

class _VoiceContentWidgetState extends State<VoiceContentWidget> {
  String text = "Say 'Ok Sunday'";
  String keyFlare = FlareConstants.keyStand;
  bool isEnable = false;

  void _remoteDevice(bool value) {
    BlocProvider.of<ControlDeviceBloc>(context)
        .add(RemoteDeviceEvent(RemoteModel("Light", value)));
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
          text = "Listening...";
          keyFlare = FlareConstants.keyThink;
        });
      } else if (data.toString().contains("LISTENING")) {
        setState(() {
          text = "Say '${VoskConstants.wakeup}'";
          keyFlare = FlareConstants.keyStand;
        });
      } else {
        final action = data.toString();
        setState(() {
          // Xét điều  khiển
          if (action.contains(VoskConstants.turnOn)) {
            _remoteDevice(ControlRemoteConstants.turnOn);
            text = VoskConstants.turnOn;
          } else if (action.contains(VoskConstants.turnOff)) {
            _remoteDevice(ControlRemoteConstants.turnOff);
            text = VoskConstants.turnOff;
          } else {
            //Hủy bỏ hành động
            if (action.contains(VoskConstants.cancel)) {
              text = "Cancel action";
            } else {
              text = "Don't understand";
            }
          }
          keyFlare = FlareConstants.keyOkay;
        });
      }
    }).onError((err) {
      setState(() {
        text = "Voice recognition is not available";
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.w,
          width: 200.w,
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
            'Voice recognition is not available',
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
