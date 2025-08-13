import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/widgets/theme_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/fonts.dart';
import '../../constants/strings.dart';
import '../help_screen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constants.totalWidth(context) * 0.1),
            child: Image.asset(Constants.logo),
          ),
          SizedBox(height: Constants.cardMargin(context)),
          ThemeCard(
            width: Constants.totalWidth(context),
            child: Column(
              children: [
                Text(
                  Constants.title,
                  textAlign: TextAlign.center,
                  style: Fonts.extraBold.copyWith(
                    fontSize: Constants.totalWidth(context) * 0.05,
                    color: Themes.cardText,
                  ),
                ),
                SizedBox(height: 0.3*Constants.pageMargin(context)),
                Row(
                  children: [
                    Text(
                      'About the Application',
                      textAlign: TextAlign.start,
                      style: Fonts.bold.copyWith(
                        fontSize: Constants.totalWidth(context) * 0.04,
                        color: Themes.cardText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.1*Constants.pageMargin(context)),
                Text(
                  Constants.about,
                  style: Fonts.regular.copyWith(
                    fontSize: Constants.totalWidth(context) * 0.03,
                    color: Themes.cardText,
                  ),
                ),
                SizedBox(height: 0.2*Constants.pageMargin(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(Constants.aboutAuth,style: Fonts.medium.copyWith(
                      fontSize: Constants.totalWidth(context) * 0.03,
                      color: Themes.cardText,
                    ),),
                  ],
                ),
                SizedBox(height: 0.2*Constants.pageMargin(context)),
                SizedBox(
                  width: Constants.totalWidth(context)*0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Hyperlink(text: 'Project Repository', url: 'https://github.com/LiquidGalaxyLAB/Eco-Explorer'),
                          Hyperlink(text: 'License', url: ''),
                          Hyperlink(text: 'LinkedIn', url: 'https://www.linkedin.com/in/shuvam-swapnil-dash-4183ab287/'),
                          Hyperlink(text: 'Github', url: 'https://github.com/Ssdosaofc'),
                          Hyperlink(text: 'Email', url: 'mailto:shuvamswapnil21@gmail.com'),
                        ],
                      ),
                      SizedBox(width: 0.03*Constants.totalWidth(context)),
                      Container(
                        height: 0.155*Constants.totalHeight(context),
                        width: 1,
                        color: Colors.grey[700],
                      ),
                      SizedBox(width: 0.03*Constants.totalWidth(context)),
                      SizedBox(
                        width: Constants.totalWidth(context)*0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Constants.aboutImg,
                              style: Fonts.bold.copyWith(
                                fontSize: Constants.totalWidth(context) * 0.04,
                                color: Themes.cardText,
                              ),
                            ),
                            SizedBox(height: 0.01*Constants.totalHeight(context)),
                            Text(
                              Constants.aboutAttr,
                              style: Fonts.medium.copyWith(
                                fontSize: Constants.totalWidth(context) * 0.025,
                                color: Themes.cardText,
                              ),
                            ),
                            SizedBox(height: 0.01*Constants.totalHeight(context)),
                            Row(
                              children: [
                                Hyperlink(text: 'PNGTree', url: 'https://pngtree.com/'),
                                SizedBox(width: 0.02*Constants.totalWidth(context)),
                                Hyperlink(text: 'Sketchfab', url: 'https://sketchfab.com/'),
                              ],
                            ),
                            Row(
                              children: [
                                Hyperlink(text: 'TurboSquid', url: 'https://www.turbosquid.com/'),
                                SizedBox(width: 0.02*Constants.totalWidth(context)),
                                Hyperlink(text: 'Free3D', url: 'https://free3d.com/')
                              ],
                            ),
                            Row(
                              children: [
                                Hyperlink(text: 'CGTrader', url: 'https://www.cgtrader.com/'),
                                SizedBox(width: 0.02*Constants.totalWidth(context)),
                                Hyperlink(text: 'Lottie', url: 'https://lottiefiles.com/'),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: Constants.cardMargin(context)),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.cardRadius(context)),
            ),
            padding: EdgeInsets.all(Constants.cardPadding(context)),
            child: Column(
              children: [
                SizedBox(
                  height: Constants.totalHeight(context) * 0.075,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(Constants.lgLogo),
                      Image.asset(Constants.gsocLogo),
                    ],
                  ),
                ),
                SizedBox(height: Constants.totalHeight(context) * 0.025),
                SizedBox(
                  height: Constants.totalHeight(context) * 0.05,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Constants.totalHeight(context) * 0.005),
                        child: Image.asset(Constants.logoLGEU),
                      ),
                      Image.asset(Constants.labLogo),
                      Image.asset(Constants.gdgLogo),
                    ],
                  ),
                ),
                SizedBox(height: Constants.totalHeight(context) * 0.025),
                SizedBox(
                  height: Constants.totalHeight(context) * 0.065,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(Constants.flutterLleidaLogo),
                      Image.asset(Constants.ticLogo),
                      Image.asset(Constants.pcitalLogo),
                    ],
                  ),
                ),
                SizedBox(height: Constants.totalHeight(context) * 0.025),
                SizedBox(
                  height: Constants.totalHeight(context) * 0.06,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(Constants.buildWithAILogo),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Constants.totalHeight(context) * 0.005),
                        child: Image.asset(Constants.groqLogo),
                      ),
                      Image.asset(Constants.liquidGalaxyAILogo),
                    ],
                  ),
                ),
                SizedBox(height: Constants.totalHeight(context) * 0.025),
                SizedBox(
                  height: Constants.totalHeight(context) * 0.06,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(Constants.iitLogo),
                      Image.asset(Constants.androidLogo),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Constants.totalHeight(context) * 0.005),
                        child: Image.asset(Constants.flutterLogo),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Constants.bottomGap(context)),
        ],
      ),
    );
  }
}
