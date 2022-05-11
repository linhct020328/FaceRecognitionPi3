import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AppEvent {}

class LoggedIn extends AppEvent{
  final String token;

  const LoggedIn({this.token});

  @override
  // TODO: implement props
  List<Object> get props => [token];
}

class LogOuted extends AppEvent{}
