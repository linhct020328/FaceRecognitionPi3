import 'package:equatable/equatable.dart';

class Device extends Equatable {
  String mqttBroker;
  int port;
  String clientID;
  String userName;
  String password;
  String topic;

  @override
  List<Object> get props =>
      [mqttBroker, port, clientID, userName, password, topic];

  Device(
      {this.mqttBroker,
      this.port,
      this.clientID,
      this.userName,
      this.password,
      this.topic});

  Device.fromJson(Map<String, dynamic> json) {
    mqttBroker = json['mqttBroker'];
    port = json['port'];
    clientID = json['clientID'];
    userName = json['userName'];
    password = json['password'];
    topic = json['topic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mqttBroker'] = this.mqttBroker;
    data['port'] = this.port;
    data['clientID'] = this.clientID;
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['topic'] = this.topic;
    return data;
  }
}
