import 'package:flutter/material.dart';

import '../constants/strings.dart';

void showSnackBar(BuildContext context, String data, Color color){
  final snackBar = SnackBar(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.totalWidth(context)/20)),
    backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(textColor:Colors.white,label: 'Dismiss', onPressed: (){
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }),
      content: Text(data,style: TextStyle(color: Colors.white),)
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
