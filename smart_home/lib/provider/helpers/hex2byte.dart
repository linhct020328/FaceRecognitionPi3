import 'package:convert/convert.dart';
import 'dart:convert';
import 'dart:typed_data';

class ByteUtils {
  static List<String> hexArray = '0123456789ABCDEF'.split('');

  static Uint8List hexToBytes(String hexStr) {
    final bytes = hex.decode(strip0x(hexStr));
    if (bytes is Uint8List) return bytes;

    return Uint8List.fromList(bytes);
  }

  static String strip0x(String hex) {
    if (hex.startsWith('0x')) return hex.substring(2);
    return hex;
  }
}