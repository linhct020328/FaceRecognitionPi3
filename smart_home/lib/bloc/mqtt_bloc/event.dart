import 'package:equatable/equatable.dart';
import 'package:smarthome/model/mqtt/message.dart';

abstract class MQTTEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

//class InitMQTTService extends MQTTEvent{}

class DisconnectMQTTT extends MQTTEvent {}

class ConnectMQTTService extends MQTTEvent {
  final String ip;

  ConnectMQTTService(this.ip);

  @override
  // TODO: implement props
  List<Object> get props => [ip];
}

class SendMessage extends MQTTEvent {
  final Message message;

  SendMessage({this.message}) : assert(message != null);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
