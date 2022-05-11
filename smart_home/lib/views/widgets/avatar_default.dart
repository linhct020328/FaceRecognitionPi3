import 'package:flutter/material.dart';

class AvatarDefault extends StatelessWidget {
  final double radius;
  final String avatar;

  AvatarDefault({this.radius, this.avatar});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 20,
      backgroundImage:  AssetImage(avatar) ,
    );
  }
}
