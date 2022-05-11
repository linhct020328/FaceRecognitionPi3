import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  @override
  List<Object> get props => [];
}

class AppUninitialized extends AppState {}

class AppAuthenticated extends AppState {}

class AppUnauthenticated extends AppState {}

class AppLoading extends AppState {}