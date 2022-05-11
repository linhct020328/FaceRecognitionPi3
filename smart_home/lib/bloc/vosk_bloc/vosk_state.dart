part of 'vosk_bloc.dart';

abstract class VoskState extends Equatable {
  const VoskState();
}

class VoskUnInitial extends VoskState {
  @override
  List<Object> get props => [];
}

class VoskInited extends VoskState {
  @override
  List<Object> get props => [];
}

class VoskListening extends VoskState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VoskWakeup extends VoskState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VoskStopped extends VoskState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VoskCancel extends VoskState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VoskError extends VoskState {
  String typeError;

  VoskError(this.typeError);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
