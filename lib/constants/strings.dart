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

  static const String title = 'Eco Explorer for Liquid Galaxy';
  static const String connected = 'LG CONNECTED';
  static const String disconnected = 'LG DISCONNECTED';
  static const String search = 'Search';

  static const String tour = 'Tour in Progress';
  static const String rig = 'Rig Controller';
  static const String listen = 'Listening...';
  static const String transcribe = 'TRANSCRIBED TEXT';

  //about data
  static const String logo = 'assets/logos/logo.png';
  static const String lgLogo = 'assets/logos/lg.png';
  static const String gsocLogo = 'assets/logos/gsoc.png';
  static const String logoLGEU = 'assets/logos/LogoLGEU.png';
  static const String labLogo = 'assets/logos/lab.png';
  static const String gdgLogo = 'assets/logos/gdg.png';
  static const String flutterLleidaLogo = 'assets/logos/flutter_lleida.png';
  static const String ticLogo = 'assets/logos/tic.png';
  static const String pcitalLogo = 'assets/logos/pcital.png';
  static const String buildWithAILogo = 'assets/logos/buildwithai.png';
  static const String groqLogo = 'assets/logos/groq.png';
  static const String liquidGalaxyAILogo = 'assets/logos/LiquidGalaxyAI.png';
  static const String iitLogo = 'assets/logos/iit.png';
  static const String androidLogo = 'assets/logos/android.png';
  static const String flutterLogo = 'assets/logos/flutter.png';

  //help data


  static const double mapScale = 10;
  static const double tourScale = 16;
  static const double orbitScale = 13;
  static const double defaultScale = 2;

  static const double forestAltitude = 4000000;
  static const double biodivAltitude = 200;
  static const double zoomedFireAltitude = 100000;
  static const double orbitAltitude = 500000;
  static const double tourAltitude = 5000;

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
  static const page = 'https://raw.githubusercontent.com/Ssdosaofc/Assets-Repo/refs/heads/main/eco-explorer';
  static const overlay = '$page/overlay.png';
  static const low = '$page/low.png';
  static const med = '$page/mid.png';
  static const high = '$page/high.png';
  static const fireIcon = '$page/fireIcon.png';
  static const fireImage = '$page/fireImage.jpg';
  static const lossImage = '$page/lossImage.jpg';
  static String forestImage(String path) => '$page/forest/$path.png';
  static String speciesImage(String path, String species) => '$page/biodiv/$path/$species.png';

  static const aqiDb = 'AQI';
  static const histAqiDb = 'HIST_AQI';
  static const fireDb = 'FIRE';

  static const openWeatherApiKey = '';
  static const nasaFirmsApiKey = '';
  static const groqApiKey = '';
  static const deepgramApiKey = '';
}