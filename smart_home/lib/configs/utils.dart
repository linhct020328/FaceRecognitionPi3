import 'dart:convert';

import 'package:flutter/material.dart';

class Utils{
  static Image imageFromBase64String(String base64String) {
    // final UriData data = Uri.parse(base64String).data;
    return Image.memory(base64Decode(base64String),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      fit: BoxFit.cover,
    );
  }
}