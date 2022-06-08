import 'package:flutter/material.dart';

class ReceiveNotificationEntity {
  int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotificationEntity(
      {int id, @required this.title, @required this.body, this.payload}) {
    final now = DateTime.now();
    if (id == null) this.id = now.second + now.millisecond;
  }
}
