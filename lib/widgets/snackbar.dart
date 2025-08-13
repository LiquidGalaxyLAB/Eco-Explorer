import 'package:eco_explorer/constants/strings.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String data, Color color){
  final snackBar = SnackBar(
    duration: Duration(seconds: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.totalWidth(context)/20)),
    backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(textColor:Colors.white,label: 'Dismiss', onPressed: (){
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }),
      content: Text((data=='Null check operator used on a null value')?'Not connected to the rig':data,style: TextStyle(color: Colors.white),)
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
