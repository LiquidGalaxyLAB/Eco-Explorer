import 'package:flutter/cupertino.dart';

class Constants{

  static const String remoteFile = '/var/www/html/';
  static int leftRig(int noOfRigs)=> (noOfRigs/2).floor() + 2;
  static int rightRig(int noOfRigs)=> (noOfRigs/2).floor() + 1;

  static const Duration screenshotDelay = Duration(milliseconds: 1000);

  static const String continents = 'assets/continents';
  static const String biodiv = 'assets/biodiv';
  static const String home = 'assets/home';
  static const String fire = 'assets/catastrophe/fire.png';
  static const String leaf = 'assets/catastrophe/leaf.png';
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

  static const String title = 'Eco Explorer for Liquid Galaxy';
  static const String connected = 'LG CONNECTED';
  static const String disconnected = 'LG DISCONNECTED';
  static const String search = 'Search';

  static const String listen = 'Listening...';
  static const String transcribe = 'TRANSCRIBED TEXT';

  //about data
  static const String about = '⬧ This project was created during the Google Summer of Code 2025 alongside the Liquid Galaxy organization. \n⬧ This app has been developed by Shuvam Swapnil Dash (email: shuvamswapnil21@gmail.com) under Liquid Galaxy, thanks to the Google Summer of Code 2025 Program. \n⬧ \n⬧ \n⬧ \n⬧ ';
  static String aboutAuth = "Created & Maintained By - Shuvam Swapnil Dash\nMentors - Gabry Izquierdo, Alfredo Bautista\nOrganization Admin - Andreu Ibáñez\nLleida Liquid Galaxy LAB support - ";
  static String aboutImg = "Attributions";
  static String aboutAttr = "The following resources were used for the project.";

  //help data
  static const String title1 = 'API Keys';
  static const String title2 = 'Rig Controller';
  static const String title3 = 'Application Voice Module';

  static const String subtitle1 = 'Groq API';
  static const String subtitle2 = 'Deepgram API';
  static const String subtitle3 = 'OpenWeather API';
  static const String subtitle4 = 'NASA FIRMS API';
  static const String subtitle5 = 'Voice Commands';
  static const String subtitle6 = 'Home Screen';
  static const String subtitle7 = 'Dashboard Screen';
  static const String subtitle8 = 'Common Commands';

  static const String hyperlink1 = 'Groq Documentation';
  static const String hyperlink2 = 'Groq API Keys';
  static const String hyperlink3 = 'Deepgram API Docs';
  static const String hyperlink4 = 'Text to Speech API';
  static const String hyperlink5 = 'Air Pollution API Docs';
  static const String hyperlink6 = 'Free API Access';
  static const String hyperlink7 = 'FIRMS Map Key';

  static const String groqDesc = 'Groq API is used to auto-generate tours across the forests curated to the needs of the user. It creates a travel itinerary, guiding along the forest whilst visualizing on the Liquid Galaxy rig.';
  static const String deepgramDesc = 'Deepgram API assists you with a virtual tour guide for your personalized tour experience along the forest.';
  static const String openWeatherDesc = 'Air Pollution API gains access to the current and historical environmental quality data of the desired location.';
  static const String firmsDesc = 'FIRMS API fetches the various active and recent fire detection hotspots based on area, date and sensor.';

  static const String commands = '⬧ ZOOM IN: Zooms the rig out\n⬧ ZOOM OUT: Zooms the rig in\n⬧ MOVE UP: Moves the rig upwards\n⬧ MOVE DOWN: Moves the rig downwards\n⬧ MOVE LEFT: Moves the rig to the left\n⬧ MOVE RIGHT: Moves the rig to the right\n⬧ ORBIT: Orbit around the location';
  static const String appCommands = '⬧ HOME: Navigates to Home Screen\n⬧ API: Navigates to API Authentication Screen\n⬧ PREFERENCES/SETTINGS: Navigates to Preferences Screen\n⬧ ABOUT: Navigates to About Screen\n⬧ To navigate to the dashboard of a forest, speak out the name of the forest.';
  static const String commonCommands = '⬧ HELP: Navigates to Help Screen\n⬧ EXIT: Exits the application';
  static const String dashboardCommands = '⬧ INFORMATION/INFO: Navigates to Information Screen\n⬧ BIODIVERSITY: Navigates to Biodiversity Screen\n⬧ ENVIRONMENT: Navigates to Environment Screen\n⬧ CATASTROPHE/DISASTER: Navigates to Catastrophe Screen\n⬧ BACK: Goes back to Home Screen\n⬧ SATELLITE: Switches map type to Satellite\n⬧ TERRAIN: Switches map type to Terrain\n⬧ HYBRID: Switches map type to Hybrid';

  static const double mapScale = 6.25;
  static const double fireScale = 13;
  static const double orbitScale = 10;
  static const double defaultScale = 15;

  static const double forestAltitude = 1000000;
  static const double biodivAltitude = 200;
  static const double zoomedFireAltitude = 100000;
  static const double tourAltitude = 2000;

  //map control
  static const double latStep = 0.0005;
  static const double lonStep = 0.0005;
  static const double tiltStep = 1.0;
  static const double headingStep = 2.0;
  static const double zoomStep = 50;

  static cardRadius(context) => MediaQuery.of(context).size.height*0.025;
  static buttonRadius(context) => MediaQuery.of(context).size.height*0.015;
  static totalWidth(context) => MediaQuery.of(context).size.width;
  static totalHeight(context) => MediaQuery.of(context).size.height;
  static pageMargin(context) => MediaQuery.of(context).size.height*0.1;
  static cardMargin(context) => MediaQuery.of(context).size.height*0.02;
  static homeCardMargin(context) => MediaQuery.of(context).size.height*0.04;
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
  static const lossImage = '$page/lossImage.png';
  static String forestImage(String path) => '$page/forest/$path.png';
  static String speciesImage(String path, String species) => '$page/biodiv/$path/$species.png';

  static const models = '3D_models';
  static const dataFile = 'data';

  static const aqiDb = 'AQI';
  static const histAqiDb = 'HIST_AQI';
  static const fireDb = 'FIRE';

  static const openWeatherApiKey = '10aad7c7eadcf036548ea217470e5000';
  static const nasaFirmsApiKey = '290b6059109dc80f959eb2ba4e78001d';
  static const groqApiKey = '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';
  static const deepgramApiKey = '70dc0c5e148d3a77b8c245985613b03562154c33';

  static const String filename = 'filename.kml';
}