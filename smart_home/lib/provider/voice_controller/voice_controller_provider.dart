import 'package:flutter/services.dart';

class VoiceControllerProvider {
  final inited = "INITED";
  final listening = "LISTENING";
  final wakeup = "WAKEUP";
  final stopped = "STOPPED";
  final cancel = "CANCEL";
  final timeout = "TIMEOUT";
  final error = "ERROR";


  static const _voskChannelString = "attendance_app/vosk";
  static const _initMethod = "initVosk";
  static const _voskChannel = MethodChannel(_voskChannelString);

  static const _voskWakeupChannelString = "attendance_app/vosk/wakeup";
  static const _voskWakeupChannel = MethodChannel(_voskWakeupChannelString);

  // method channel
  static const _startVoskWakupMethod = "startVoskWakeup",
      _stopVoskWakupMethod = "stopVoskWakeup",
      _cancelVoskWakupMethod = "cancelVoskWakeup";

  static const _wakeupStreamChannelString = "attendance_app/vosk/wakeup/listen";
  static const wakeupStreamChannel =
  const EventChannel(_wakeupStreamChannelString);


  @override
  Future<bool> initVosk() async {
    try {
      String result = await _voskChannel.invokeMethod(_initMethod);
      print('>>> result $result');

      if (result.contains(inited)) {
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      return false;
    }
  }

  @override
  Future<bool> startVosk() async {
    try {
      String result =
          await _voskWakeupChannel.invokeMethod(_startVoskWakupMethod);

      if (result == listening) {
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      return false;
    }
  }

  @override
  Future<bool> stopVosk() async {
    try {
      String result = await _voskWakeupChannel.invokeMethod(_stopVoskWakupMethod);

      if (result == stopped) {
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      return false;
    }
  }
}
