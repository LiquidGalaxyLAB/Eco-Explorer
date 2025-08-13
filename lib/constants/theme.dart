import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//backgrounds
class Themes{
  static Color bg = Color(0xff10150A);
  static Color assistantBg = Colors.black;
  static Color bottomNav = Colors.black;
  static Color primaryText = Colors.white;

  static Color secondaryText = Color(0xffF6FBE6);

  static Color disconnected = Colors.red;
  static Color connected = Colors.green;

  static Color error = Color(0xff6F2124);

  static Color timelapse = Color(0xffA7ED37);

  static Color hyperlink = Colors.blue;

//textbox
  static Color textboxOutline = Color(0xffE0E5D2);
  static Color textboxLabel = Color(0xffE0E5D2);
  static Color textboxHint = Color(0xff808080);

//card
  static Color cardOutline = Color(0xff8B947C);
  static Color cardBg = Color(0xff1D2115);
  static Color cardText = Color(0xffE0E5D2);

//buttons
  static Color logoInactive = Color(0xffE0E5D2);
  static Color logoActive = Color(0xffA8EC4E);

  static Color primaryButtonBg = Color(0xffE0E5D2);
  static Color primaryButtonFill = Color(0xff1D2115);

  static Color secondaryButtonBg = Color(0xff424936);
  static Color secondaryButtonFill = Color(0xffC0C9B1);

  static Color mapInactiveBg = Color(0xff253925);
  static Color mapInactiveText = Color(0xffFFFFFF);
  static Color mapActiveBg = Color(0xffC1CAB0);
  static Color mapActiveText = Color(0xff1D2115);

  static Color orbitBg = Colors.white;
  static Color orbitFill = Color(0xff1C1B1F);

  static Color controllerBg = Colors.black;
  static Color controllerFill = Colors.white;

  static Color openControllerBg = Colors.white;
  static Color openControllerFill = Colors.black;

  static Color graph = Color(0xff58E259);
  static Color smoothGraph = Color(0xffE56449);
}

//levels
Color good = Colors.green;
Color fair = Color(0xffAEFF00);
Color moderate = Colors.yellow;
Color poor = Colors.orange;
Color veryPoor = Colors.red;
Color hazardous = Colors.red[900]!;

LinearGradient gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      good, fair, moderate, poor, veryPoor,
    ],
    // stops: [0.2,0.4,0.6,0.8,1.0]
);

Color aqiColor(double aqi){
  switch(aqi){
    case ==1:
      return good;
    case ==2:
      return fair;
    case ==3:
      return moderate;
    case ==4:
      return poor;
    case ==5:
      return veryPoor;
    // case >=301:
    //   return hazardous;
    default:
      return Colors.grey;
  }
}

