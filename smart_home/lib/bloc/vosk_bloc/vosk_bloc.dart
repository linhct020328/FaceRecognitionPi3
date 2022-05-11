import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smarthome/provider/voice_controller/voice_controller_provider.dart';

part 'vosk_event.dart';

part 'vosk_state.dart';

class VoskBloc extends Bloc<VoskEvent, VoskState> {
  VoiceControllerProvider voskControlProvider;

  VoskBloc(this.voskControlProvider);

  @override
  Stream<VoskState> mapEventToState(
    VoskEvent event,
  ) async* {
    if (event is InitVoskEvent) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.storage,
      ].request();
      debugPrint(statuses[Permission.location].toString());
      final result = await voskControlProvider.initVosk();
      yield result ? VoskInited() : VoskError("INITED");
    } else if (event is StopVoskEvent) {
      final result = await voskControlProvider.stopVosk();
      yield result ? VoskStopped() : VoskError("STOPPED");
    } else if (event is StartVoskEvent) {
      final result = await voskControlProvider.startVosk();
      yield result ? VoskInited() : VoskError("LISTENING");
    }
  }

  @override
  // TODO: implement initialState
  VoskState get initialState => VoskUnInitial();
}
