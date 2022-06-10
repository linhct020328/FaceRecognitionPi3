import 'dart:io';
import 'package:smarthome/provider/helpers/hex2byte.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smarthome/provider/helpers/crypt.dart';

class Utils {
  static Future<Image> saveImageToStorage(String aesString) async {
    final now = DateTime.now();
    final imgHex = crypt.aesDecrypt(aesString);
    final imgByte = ByteUtils.hexToBytes(imgHex);

    final downloadPath = await getDownloadPath();
    File pathFile = File('$downloadPath/image-${now.toIso8601String()}.jpg');
    final ImgSave =  await pathFile.writeAsBytes(imgByte);
    return Image.file(ImgSave);
  }

  static Future<String> getDownloadPath() async {
    Directory directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }
}
