import 'package:flutter/material.dart';

class ExitAlertDialog extends StatelessWidget {

  const ExitAlertDialog({this.yesCallback});

  final Function yesCallback;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Text('Warning'),
      content: Text('Do you really want to exit?'),
      actions: [
        FlatButton(
          child: Text('Yes'),
          onPressed: (){
            if(yesCallback!=null){
              yesCallback();
            }
            Navigator.pop(context, true);
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
