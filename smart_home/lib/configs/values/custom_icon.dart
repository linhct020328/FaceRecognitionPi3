import 'package:flutter/widgets.dart';

class CustomIcon {
  CustomIcon._();

  static const _airFont = 'Air';
  static const _light_home_font = 'LightHome';
  static const _tempFont = 'Temp';
  static const _waterFont = 'Water';
  static const _oneWaterFont = 'OneWater';

  static const _kFontPkg = null;

  static const IconData air = IconData(0xe800, fontFamily: _airFont, fontPackage: _kFontPkg);
  static const IconData light = IconData(0xe800, fontFamily: _light_home_font, fontPackage: _kFontPkg);
  static const IconData home = IconData(0xe801, fontFamily: _light_home_font, fontPackage: _kFontPkg);
  static const IconData temp = IconData(0xe800, fontFamily: _tempFont, fontPackage: _kFontPkg);
  static const IconData water = IconData(0xe800, fontFamily: _waterFont, fontPackage: _kFontPkg);
  static const IconData oneWater = IconData(0xeae4, fontFamily: _oneWaterFont, fontPackage: _kFontPkg);
}
