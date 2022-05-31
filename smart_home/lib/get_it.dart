import 'package:http/http.dart';
import 'package:smarthome/bloc/app_bloc/app_bloc.dart';
import 'package:smarthome/bloc/vosk_bloc/vosk_bloc.dart';
import 'package:smarthome/provider/local/local_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:smarthome/provider/remote/authentication_provider.dart';
import 'package:smarthome/provider/remote/control_device_provider.dart';
import 'package:smarthome/provider/voice_controller/voice_controller_provider.dart';
import 'package:smarthome/repositories/authentication_repo.dart';
import 'package:smarthome/repositories/control_device_repo.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AppBloc());

  locator.registerLazySingleton(() => VoskBloc(locator()));

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
