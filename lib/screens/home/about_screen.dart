import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/widgets/theme_card.dart';
import 'package:flutter/cupertino.dart';

import '../../constants/fonts.dart';
import '../../constants/strings.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemeCard(
            width: Constants.totalWidth(context),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constants.totalWidth(context)*0.1),
                  child: Image.asset('assets/logos/logo.png'),
                ),
                SizedBox(height: Constants.cardMargin(context),),
                Text(Constants.title, maxLines: 2, textAlign: TextAlign.center,
                  style: Fonts.extraBold.copyWith(fontSize: 30,color: Themes.cardText),),
                SizedBox(height: Constants.pageMargin(context),),
              ],
            )
        ),
        SizedBox(height: Constants.bottomGap(context),)
      ],
    );
  }
}
