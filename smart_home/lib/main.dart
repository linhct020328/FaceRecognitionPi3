import 'package:smarthome/app.dart';
import 'package:smarthome/bloc/app_bloc/bloc.dart';
import 'package:smarthome/bloc_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'get_it.dart';

void main() {
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();

  // set color status bar and navigationbar
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  // setup get it : MQTT service
  BlocSupervisor.delegate = AppBlocDelegate(); // setup logging bloc
  // set only vertical screen
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(BlocProvider<AppBloc>(
        create: (context) => locator<AppBloc>()
          ..add(
            AppStarted(),
          ),
        child: MyApp()));
  });
}
