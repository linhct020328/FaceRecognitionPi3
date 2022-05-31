import 'package:smarthome/configs/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class LoadingDialog {
  static void show(BuildContext context, {String mess}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                ),
                Visibility(
                  visible: mess != null,
                  child: Text(
                    mess.toString(),
                    style: Theme.of(context)
                        .primaryTextTheme
                        .caption
                        .copyWith(fontSize: ScreenUtil().setSp(fzCaption)),
                  ),
                ),
              ],
            ));
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
  }
}
