//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:smarthome/bloc/update_data_bloc/bloc.dart';
//import 'package:smarthome/provider/mqtt/mqtt_service.dart';
//import 'file:///F:/StudySpace/University/4thYear/thietkehethongnhung/smart_home/lib/get_it.dart';
//
//class UpdateDataBloc extends Bloc<UpdateDataEvent, UpdateDataState> {
//  final _mqttService = locator<MQTTService>();
//
//  @override
//  // TODO: implement initialState
//  UpdateDataState get initialState => LoadedData();
//
//  @override
//  Stream<UpdateDataState> mapEventToState(UpdateDataEvent event) async* {
//    // TODO: implement mapEventToState
//    if (event is RemoteDevice) {
//      yield* _sendMessage(event);
//    }
//  }
//
//  Stream<UpdateDataState> _sendMessage(RemoteDevice event) async* {
//    try {
//      _mqttService.sendMessage(event.message);
//    } catch (e) {
//      if (state is FailedData) {
//        yield (state as FailedData).copyWith();
//      } else {
//        yield FailedData(
//            error: "Error! An error occurred. Please try again later");
//      }
//    }
//  }
//}
