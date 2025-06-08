import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../constants/theme.dart';

class ThemeCard extends StatelessWidget {
  final double width;
  final Function? onTap;
  final Widget child;
  const ThemeCard({super.key, required this.width, this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (onTap != null) onTap!();
        },
        child: Container(
        padding: EdgeInsets.all(Constants.cardPadding(context)),
        // height: height!,
        width: width,
        decoration: BoxDecoration(
          color: Themes.cardBg,
          borderRadius: BorderRadius.all(Radius.circular(Constants.cardRadius(context))),
          border: Border.all(color: Themes.cardOutline),
        ),
        child: child,
      )
    );
  }
}
