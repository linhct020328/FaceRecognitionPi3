import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smarthome/model/mqtt/message.dart';
import 'package:smarthome/provider/helpers/crypt.dart';

class MQTTService {
  final int _keepAlivePeriod = 20;
  final bool _autoReconnect = true;

  MqttServerClient _client;

  MqttServerClient get client => _client;

  final String clientId;

  final String host;
  final int port;
  final String topic;
  final String username;
  final String password;

  MQTTService(
      {this.clientId,
      this.host,
      this.topic,
      this.username,
      this.password,
      this.port});

  Future initMQTT() async {
    _client = MqttServerClient.withPort(host, clientId, port);
    _client.secure = true;
    _client.logging(on: true);
    _client.keepAlivePeriod = _keepAlivePeriod;

    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;
    _client.onUnsubscribed = _onUnsubscribed;
    _client.autoReconnect = _autoReconnect;
    _client.pongCallback = _pong;

    final context = SecurityContext.defaultContext;

    String clientAuth =
        await rootBundle.loadString("assets/certs_localhost/mqtt_ca.crt");

    context.setTrustedCertificatesBytes(clientAuth
        .codeUnits); // context.setClientAuthoritiesBytes(clientAuth.codeUnits);
    String trustedCer =
        await rootBundle.loadString("assets/certs_localhost/mqtt_client.crt");
    context.useCertificateChainBytes(trustedCer.codeUnits);
    String privateKey =
        await rootBundle.loadString("assets/certs_localhost/mqtt_client.key");
    context.usePrivateKeyBytes(privateKey.codeUnits);

    final connMess = MqttConnectMessage()
        .authenticateAs(username, password)
        .keepAliveFor(20) // Must agree with the keep alive set above or not set
        .withWillTopic(
            'will-topic') // If you set this you must set a will message
        .withWillMessage('Test message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    _client.connectionMessage = connMess;
  }

  connectMQTT() async {
    try {
      await _client.connect();
    } on Exception catch (e) {
      _client.disconnect();
      throw Exception('Client MQTT exception - $e');
    }
  }

  disconnectMQTT() => _client.disconnect();

  sendMessage(String message) {
    try {
      final builder = MqttClientPayloadBuilder();
      var msgEncode = crypt.aesEncrypt(message); //encoder
      builder.addString(msgEncode);
      _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void _onConnected() {
    debugPrint('>>> Connected');
  }

  void _onDisconnected() {
    debugPrint('>>> Client disconnection');
  }

  void _onSubscribed(String topic) {
    debugPrint('>>> Subscription $topic');
  }

  void _onUnsubscribed(String topic) {
    debugPrint('>>> UnSubscription $topic');
  }

  /// Pong callback
  void _pong() {
    debugPrint('>>> Ping response client callback invoked');
  }
}