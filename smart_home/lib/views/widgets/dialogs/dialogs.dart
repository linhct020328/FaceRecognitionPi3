
import 'package:smarthome/configs/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDialog {
  static void showNotifyDialog({
    @required BuildContext context,
    @required String mess,
    @required String textBtn,
    @required Function function,
    @required Color color,
  }) {
    showDialog(
        context: context,
        builder: (context) {

          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            backgroundColor: bgWhite,
            elevation: 5,
            title: Text('Lỗi', style: Theme.of(context).primaryTextTheme.title.copyWith(color: colorNoAttend),),
            content:  Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    mess,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .subtitle.copyWith(color: colorTextBlack)
                ),
                SizedBox(height: ScreenUtil().setHeight(40),),
                FlatButton(
                    child: Text(
                        textBtn,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .button
                    ),
                    color: color,
                    onPressed: function),
              ],
            ),
            );
        },
        barrierDismissible: false);
  }

  static void showActionsDialog({
    @required BuildContext context,
    @required String mess,
    @required String textBtnR,
    @required String textBtnL,
    @required Color colorR,
    @required Color colorL,
    @required Function functionR,
    @required Function functionL,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Text(
                      mess,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle.copyWith(color: colorTextBlack),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Text(
                              textBtnL,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .button.copyWith(color: colorTextWhite)
                            ),
                            color: colorL,
                            onPressed: functionL),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                            child: Text(
                              textBtnR,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .button.copyWith(color: colorTextWhite)
                            ),
                            color: colorR,
                            onPressed: functionR),
                      ],
                    ),
                  ],
                ),
            ),
          );
        },
        barrierDismissible: true);
  }
}
