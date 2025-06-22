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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 5), () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen())));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Constants.totalWidth(context)*0.6,
                child: Image.asset('assets/logos/logo.png'),
              ),
              SizedBox(height:Constants.totalHeight(context)*0.03),
              SizedBox(
                  width: Constants.totalWidth(context)*0.7,
                  child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TyperAnimatedText(
                          Constants.title, textStyle: Fonts.bold.copyWith(color: Colors.black,
                            fontSize: Constants.totalHeight(context)*0.03),textAlign: TextAlign.center,
                          speed: Duration(milliseconds: 50),
                        ),

                      ]
                  )
              ),
              SizedBox(height:Constants.totalHeight(context)*0.05),
              SizedBox(
                height: Constants.totalHeight(context)*0.075,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/logos/lg.png'),
                    Image.asset('assets/logos/gsoc.png'),
                  ],
                ),
              ),
              SizedBox(height:Constants.totalHeight(context)*0.05),
              SizedBox(
                height: Constants.totalHeight(context)*0.0325,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Constants.totalHeight(context)*0.005),
                      child: Image.asset('assets/logos/LogoLGEU.png'),
                    ),
                    Image.asset('assets/logos/lab.png'),
                    Image.asset('assets/logos/gdg.png'),
                    Image.asset('assets/logos/flutter_lleida.png'),
                    Image.asset('assets/logos/tic.png'),
                    Image.asset('assets/logos/pcital.png'),
                  ],
                ),
              ),
              SizedBox(height:Constants.totalHeight(context)*0.05),
              SizedBox(
                height: Constants.totalHeight(context)*0.0375,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/logos/buildwithai.png'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Constants.totalHeight(context)*0.005),
                      child: Image.asset('assets/logos/groq.png'),
                    ),
                    Image.asset('assets/logos/LiquidGalaxyAI.png'),
                    Image.asset('assets/logos/iit.png'),
                    Image.asset('assets/logos/android.png'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Constants.totalHeight(context)*0.005),
                      child: Image.asset('assets/logos/flutter.png'),
                    ),
                  ],
                ),
              ),
            ]
        ),
      )
    );
  }
}
