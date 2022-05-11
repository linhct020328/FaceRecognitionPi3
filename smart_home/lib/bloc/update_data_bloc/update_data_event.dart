import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/model/mqtt/message.dart';

class UpdateDataEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InitData extends UpdateDataEvent{

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class RemoteDevice extends UpdateDataEvent{
  final Message message;

  RemoteDevice({@required this.message}) : assert(message!=null);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}