import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/fonts.dart';
import '../constants/strings.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(Constants.cardPadding(context)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Constants.totalWidth(context) * 0.6,
                child: Image.asset(Constants.logo),
              ),
              SizedBox(height: Constants.totalHeight(context) * 0.03),
              SizedBox(
                width: Constants.totalWidth(context) * 0.7,
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      Constants.title,
                      textStyle: Fonts.bold.copyWith(
                        color: Colors.black,
                        fontSize: Constants.totalHeight(context) * 0.03,
                      ),
                      textAlign: TextAlign.center,
                      speed: const Duration(milliseconds: 50),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Constants.totalHeight(context) * 0.05),
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
              SizedBox(height: Constants.totalHeight(context) * 0.05),
              SizedBox(
                height: Constants.totalHeight(context) * 0.0325,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Constants.totalHeight(context) * 0.005,
                      ),
                      child: Image.asset(Constants.logoLGEU),
                    ),
                    Image.asset(Constants.labLogo),
                    Image.asset(Constants.gdgLogo),
                    Image.asset(Constants.flutterLleidaLogo),
                    Image.asset(Constants.ticLogo),
                    Image.asset(Constants.pcitalLogo),
                  ],
                ),
              ),
              SizedBox(height: Constants.totalHeight(context) * 0.05),
              SizedBox(
                height: Constants.totalHeight(context) * 0.0375,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(Constants.buildWithAILogo),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Constants.totalHeight(context) * 0.005,
                      ),
                      child: Image.asset(Constants.groqLogo),
                    ),
                    Image.asset(Constants.liquidGalaxyAILogo),
                    Image.asset(Constants.iitLogo),
                    Image.asset(Constants.androidLogo),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Constants.totalHeight(context) * 0.005,
                      ),
                      child: Image.asset(Constants.flutterLogo),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
