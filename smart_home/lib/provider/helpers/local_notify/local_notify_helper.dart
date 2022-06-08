import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'receive_notification_entity.dart';

abstract class LocalNotifyHelper {
  Future<void> initLocalNotification(
      {@required
          Future<dynamic> onDidReceiveLocalNotification(
              int id, String title, String body, String payload),
      @required
          Future<dynamic> selectNotification(String payload),
      @required
          Future<dynamic> onLaunchAppByNotification(String payload)});

  Future<void> cancelNotification(int id);

  Future<NotificationAppLaunchDetails> getNotificationAppLaunchDetails();

  Future<void> showNotification(
      ReceiveNotificationEntity entity, NotificationDetails notificationDetail);

  Future<void> createNotificationChannel(AndroidNotificationChannel channel);
}

class LocalNotifyHelperImpl implements LocalNotifyHelper {
  LocalNotifyHelperImpl(this.flutterLocalNotificationsPlugin);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  Future<void> initLocalNotification(
      {@required
          Future<dynamic> onDidReceiveLocalNotification(
              int id, String title, String body, String payload),
      @required
          Future<dynamic> selectNotification(String payload),
      @required
          Future<dynamic> onLaunchAppByNotification(String payload)}) async {
    // initialise the plugin.
    // app_icon needs to be a added as a drawable resource to the Android
    // head project
    await _initializePlatform(
        onDidReceiveLocalNotification, selectNotification);
    if(Platform.isIOS){
      await _requestIOSPermission();
    }
    await _handleOnLaunchAppByNotification(onLaunchAppByNotification);
  }

  /// fetch notification detail when open app via a notification
  /// Usually used for navigation to a particular screen when re-open app in background
  /// When using this method, [initLocalNotification] method must be called in the material app
  /// This method must be used in conjunction with [selectNotification] method
  Future _handleOnLaunchAppByNotification(
      Future onLaunchAppByNotification(String payload)) async {
    final notificationDetail =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationDetail != null &&
        notificationDetail.didNotificationLaunchApp) {
      await onLaunchAppByNotification(notificationDetail.payload);
    }
  }

  Future _initializePlatform(
      Future Function(int id, String title, String body, String payload)
          onDidReceiveLocalNotification,
      Future Function(String payload) selectNotification) async {
    final initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  @override
  Future<NotificationAppLaunchDetails> getNotificationAppLaunchDetails() =>
      flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  Future _requestIOSPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  @override
  Future<void> showNotification(ReceiveNotificationEntity entity,
      NotificationDetails notificationDetail) async {
    await flutterLocalNotificationsPlugin.show(
      entity.id,
      entity.title,
      entity.body,
      notificationDetail,
      payload: entity.payload,
    );
  }

  // cancel Notification method
  @override
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  @override
  Future<void> createNotificationChannel(
      AndroidNotificationChannel channel) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidNotificationChannel = channel;
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        .createNotificationChannel(androidNotificationChannel);
  }
}
