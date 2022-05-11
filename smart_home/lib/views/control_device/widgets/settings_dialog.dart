import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarthome/bloc/vosk_bloc/vosk_bloc.dart';

class SettingsDialog extends StatefulWidget {
  bool isVoiceEnabled;

  SettingsDialog(this.isVoiceEnabled);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool isVoiceEnabled;

  void _enableVoiceControl() {
    if (isVoiceEnabled) {
      BlocProvider.of<VoskBloc>(context).add(StopVoskEvent());
    } else {
      BlocProvider.of<VoskBloc>(context).add(StartVoskEvent());
    }
    setState(() {
      isVoiceEnabled = !isVoiceEnabled;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isVoiceEnabled = widget.isVoiceEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Voice control'),
            trailing: isVoiceEnabled == null
                ? Text("error")
                : Switch(
                    value: isVoiceEnabled,
                    onChanged: (isEnable) {
                      setState(() => _enableVoiceControl());
                    }),
          )
        ],
      ),
    );
  }
}
