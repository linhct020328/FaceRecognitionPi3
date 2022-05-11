import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smarthome/model/remote_model.dart';
import 'package:smarthome/repositories/control_device_repo.dart';

part 'control_device_event.dart';

part 'control_device_state.dart';

class ControlDeviceBloc extends Bloc<ControlDeviceEvent, ControlDeviceState> {
  final ControlDeviceRepo controlDeviceRepo;

  ControlDeviceBloc(this.controlDeviceRepo);

  @override
  Stream<ControlDeviceState> mapEventToState(
    ControlDeviceEvent event,
  ) async* {
    if (event is RemoteDeviceEvent) {
      yield* _mapRemoteEventToState(event);
    }
  }

  @override
  // TODO: implement initialState
  ControlDeviceState get initialState => ControlDeviceInitial();

  Stream<ControlDeviceState> _mapRemoteEventToState(
      RemoteDeviceEvent event) async* {
    yield SendLoading();
    final remoteModel = event.remoteModel;
    try {
      final result = await controlDeviceRepo.controlDeviceWithRPCRequest(
          remoteModel.key, remoteModel.params);
      if (result) {
        yield SendSuccess();
      } else {
        yield SendFailure();
      }
    } catch (e) {
      yield SendFailure();
    }
  }
}
