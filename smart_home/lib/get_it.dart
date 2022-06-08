import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:smarthome/bloc/app_bloc/app_bloc.dart';
import 'package:smarthome/bloc/vosk_bloc/vosk_bloc.dart';
import 'package:smarthome/provider/helpers/shared_preferences_manager.dart';
import 'package:smarthome/provider/local/local_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:smarthome/provider/remote/authentication_provider.dart';
import 'package:smarthome/provider/remote/control_device_provider.dart';
import 'package:smarthome/provider/voice_controller/voice_controller_provider.dart';
import 'package:smarthome/repositories/authentication_repo.dart';
import 'package:smarthome/repositories/control_device_repo.dart';

import 'provider/helpers/local_notify/local_notify_helper.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async{
  final sharedPrefs = SharedPreferencesManager();
  await sharedPrefs.init();

  locator.registerLazySingleton(() => AppBloc());

  locator.registerLazySingleton(() => VoskBloc(locator()));

  locator.registerLazySingleton(() => sharedPrefs);

  locator.registerLazySingleton<LocalNotifyHelper>(
      () => LocalNotifyHelperImpl(FlutterLocalNotificationsPlugin()));

  locator.registerFactory<AuthenticationRepo>(
      () => AuthenticationRepoImpl(locator()));
  locator.registerFactory<ControlDeviceRepo>(
      () => ControlDeviceRepoImpl(locator(), locator()));

  locator.registerLazySingleton<VoiceControllerProvider>(
      () => VoiceControllerProvider());
  locator.registerFactory<LocalProvider>(() => LocalProviderImpl());
  locator.registerFactory<AuthenticationProvider>(() => AuthenticationProvider(
        locator(),
      ));
  locator.registerFactory<ControlDeviceProvider>(() => ControlDeviceProvider(
        locator(),
      ));

  locator.registerFactory<Client>(() => Client());
}
