part of 'control_device_bloc.dart';

@immutable
abstract class ControlDeviceEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RemoteDeviceEvent extends ControlDeviceEvent{
  final RemoteModel remoteModel;

  RemoteDeviceEvent(this.remoteModel);

  @override
  // TODO: implement props
  List<Object> get props => [remoteModel];
}