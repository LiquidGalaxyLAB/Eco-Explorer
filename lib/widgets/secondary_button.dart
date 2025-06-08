import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/strings.dart';
import '../constants/theme.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function onTap;
  const SecondaryButton({super.key, required this.label, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: Constants.cardPadding(context), vertical: Constants.cardPadding(context)*0.5),
          decoration: BoxDecoration(
            color: Themes.secondaryButtonBg,
            borderRadius: BorderRadius.all(Radius.circular(Constants.buttonRadius(context))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: Fonts.bold.copyWith(color: Themes.secondaryButtonFill, fontSize: Constants.totalHeight(context)*0.025),),
              SizedBox(width: 10,),
              Icon(icon,color: Themes.secondaryButtonFill,size: Constants.totalHeight(context)*0.025,)
            ],
          ),
        )
    );
  }
}
