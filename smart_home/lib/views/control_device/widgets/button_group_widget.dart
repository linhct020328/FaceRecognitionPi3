import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smarthome/configs/values/colors.dart';
import 'package:smarthome/model/remote_model.dart';
import 'package:smarthome/views/control_device/bloc/control_device_bloc.dart';
import 'package:smarthome/views/widgets/dialogs/alert_dialog.dart';

class ButtonGroupWidget extends StatefulWidget {
  @override
  _ButtonGroupWidgetState createState() => _ButtonGroupWidgetState();
}

class _ButtonGroupWidgetState extends State<ButtonGroupWidget> {
  bool _isOn = true;

  @override
  Widget build(BuildContext context) {
    final sc = MediaQuery.of(context).size;

    return BlocListener<ControlDeviceBloc, ControlDeviceState>(
      listener: (context, state) {
        if (state is SendFailure) {
          AppAlertDialog.showAlert(context, 'Notification',
              'Error! An error occurred. Please try again later');
        }
        if (state is SendSuccess) {
          setState(() {
            _isOn = !_isOn;
          });
        }
      },
      child: Center(
        child: GestureDetector(
          onTap: () {
            BlocProvider.of<ControlDeviceBloc>(context)
                .add(RemoteDeviceEvent(RemoteModel("Light", !_isOn)));
          },
          child: CircleAvatar(
            backgroundColor: _isOn ? primary : Colors.grey,
            radius: 40,
            child: Icon(
              Icons.lock,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonWidget(BuildContext context, String icon, Function callBack) {
    return IconButton(
        icon: SvgPicture.asset(
          icon,
//          color: Colors.blue,
        ),
        onPressed: callBack);
  }

  void _remoteRobot(BuildContext context, String message) {
//    BlocProvider.of<UpdateDataBloc>(context)
//        .add(RemoteDevice(message: Message(mess: message)));
  }
}
