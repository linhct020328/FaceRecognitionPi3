part of 'vosk_bloc.dart';

abstract class VoskEvent extends Equatable {
  const VoskEvent();
}

class InitVoskEvent extends VoskEvent{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class StopVoskEvent extends VoskEvent{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class StartVoskEvent extends VoskEvent{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
