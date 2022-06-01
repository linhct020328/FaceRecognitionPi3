import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smarthome/provider/helpers/crypt.dart';
import 'package:smarthome/provider/helpers/hex2byte.dart';

class Utils{
  static Image imageFromAesString(String aesString) {
    final imgHex = crypt.aesDecrypt(aesString);
    final imgByte = ByteUtils.hexToBytes(imgHex);
    return Image.memory(imgByte,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      fit: BoxFit.cover,
    );
  }
}