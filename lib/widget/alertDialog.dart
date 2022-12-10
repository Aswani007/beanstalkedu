import 'package:flutter/material.dart';

class MyAlertDialogue {
  int? height;
  int? width;

  openAlertBox({@required context, height, width,body,color}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              color: color,
                height: height,
                width: width,
                child: body),
          );
        });
  }
}
