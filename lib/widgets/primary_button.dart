import 'package:eco_explorer/constants/fonts.dart';
import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../constants/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final Future<void> Function() onPressed;
  const PrimaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async{
        await onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Constants.cardPadding(context),vertical: Constants.cardPadding(context)*0.5),
        decoration: BoxDecoration(
          color: Themes.primaryButtonBg,
          borderRadius: BorderRadius.all(Radius.circular(Constants.buttonRadius(context))),
      ),
        child: Text(label, style: Fonts.bold.copyWith(color: Themes.primaryButtonFill, fontSize: Constants.totalHeight(context)*0.025),),
    )
    );
  }
}
