import 'package:flutter/cupertino.dart';

import '../constants/strings.dart';
import '../constants/theme.dart';

class ThemeDialogBox extends StatelessWidget {
  final Widget child;
  const ThemeDialogBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Constants.cardPadding(context)),
      decoration: BoxDecoration(
        color: Themes.cardBg,
        borderRadius: BorderRadius.all(Radius.circular(Constants.cardRadius(context))),
        border: Border.all(color: Themes.cardOutline),
      ),
      child: child,
    );
  }
}
