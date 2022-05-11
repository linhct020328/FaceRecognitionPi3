import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UpdateDataState extends Equatable {
  const UpdateDataState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingData extends UpdateDataState {}

class LoadedData extends UpdateDataState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FailedData extends UpdateDataState {
  final String error;
  final bool current;

  FailedData({@required this.error, this.current = true});

  FailedData copyWith({String error}) {
    return FailedData(error: error ?? this.error, current: !this.current);
  }

  @override
  List<Object> get props => [error, current];

  @override
  String toString() => 'Realtime Failure { error: $error }';
}

class RemoteSuccess extends UpdateDataState {}
