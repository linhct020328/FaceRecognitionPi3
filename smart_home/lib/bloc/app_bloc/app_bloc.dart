import 'dart:async';
import 'package:smarthome/bloc/app_bloc/app_event.dart';
import 'package:smarthome/bloc/app_bloc/bloc.dart';
import 'package:bloc/bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {

  @override
  AppState get initialState => AppUninitialized();

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppStarted) {
      yield AppAuthenticated();
    } else if (event is LoggedIn) {
      yield AppAuthenticated();
    } else if (event is LogOuted) {
      yield AppUnauthenticated();
    }
  }
}
