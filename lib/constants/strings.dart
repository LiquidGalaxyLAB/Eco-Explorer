import 'package:flutter/cupertino.dart';

class Constants{
  static const String lgUrl = 'http://lg1:81';
  static const String remoteFile = '/var/www/html/';
  static int leftRig(int noOfRigs)=> (noOfRigs/2).floor() + 2;
  static int rightRig(int noOfRigs)=> (noOfRigs/2).floor() + 1;

  static const String continents = 'assets/continents';
  static const String biodiv = 'assets/biodiv';
  static const String home = 'assets/home';
  static const String fire = 'assets/catastrophe/fire.png';
  static const String leaf = 'assets/catastrophe/leaf.png';

  static const String title = 'Eco Explorer';
  static const String connected = 'LG CONNECTED';
  static const String disconnected = 'LG DISCONNECTED';
  static const String search = 'Search';

  static const String tour = 'Tour in Progress';
  static const String rig = 'Rig Controller';
  static const String listen = 'Listening...';
  static const String transcribe = 'TRANSCRIBED TEXT';

  //about data


  //help data


  static const double mapScale = 10;
  static const double tourScale = 16;
  static const double orbitScale = 13;
  static const double defaultScale = 2;

  static cardRadius(context) => MediaQuery.of(context).size.height*0.025;
  static buttonRadius(context) => MediaQuery.of(context).size.height*0.015;
  static totalWidth(context) => MediaQuery.of(context).size.width;
  static totalHeight(context) => MediaQuery.of(context).size.height;
  static pageMargin(context) => MediaQuery.of(context).size.height*0.1;
  static cardMargin(context) => MediaQuery.of(context).size.height*0.02;
  static homeCardMargin(context) => MediaQuery.of(context).size.height*0.03;
  static cardPadding(context) => MediaQuery.of(context).size.height*0.02;
  static homeCardPadding(context) => MediaQuery.of(context).size.height*0.02;
  static bottomGap(context) => MediaQuery.of(context).size.height*0.12;

  //github links
  static const low = '';
  static const med = '';
  static const high = '';
  static const fireIcon = '';
  static const concFile = 'conc';
  static const dataFile = 'data';

  static const aqiDb = 'AQI';
  static const histAqiDb = 'HIST_AQI';
  static const fireDb = 'FIRE';

  static const openWeatherApiKey = '10aad7c7eadcf036548ea217470e5000';
  static const nasaFirmsApiKey = '77e660288acb30c53241a3d9792253b5';
  static const groqApiKey = '';
  static const deepgramApiKey = '';
}