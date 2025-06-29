import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/strings.dart';
import '../constants/theme.dart';

class ErrorDialogBox extends StatelessWidget {
  final String error;
  const ErrorDialogBox({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          // width: Constants.totalWidth(context)*0.75,
          padding: EdgeInsets.symmetric(vertical: Constants.cardPadding(context),horizontal: 1.5* Constants.cardPadding(context)),
          decoration: BoxDecoration(
            color: Themes.error,
            borderRadius: BorderRadius.all(Radius.circular(Constants.cardRadius(context))),
            border: Border.all(color: Colors.white),
          ),
          child: Column(
            children: [
              ImageIcon(AssetImage('assets/logos/error.png'),color: Colors.white,size: Constants.totalHeight(context)*0.1),
              // Icon(Icons.close, color: Colors.white,size: Constants.totalHeight(context)*0.1),
              SizedBox(height: Constants.cardMargin(context)),
              Text(error, style: Fonts.bold.copyWith(color: Colors.white,fontSize: Constants.totalHeight(context) * 0.015)),
            ],
          ),
        ),
      ),
    );
  }
}
