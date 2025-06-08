import 'package:eco_explorer/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:hive/hive.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:hive_flutter/adapters.dart';

import 'models/aqi/aqi_model.dart';
import 'models/fire/fire_model.dart';
import 'models/historical_aqi/hist_aqi_model.dart';

void main() async{
  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  if(mapsImplementation is GoogleMapsFlutterAndroid){
    mapsImplementation.useAndroidViewSurface = true;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AqiModelAdapter());
  Hive.registerAdapter(HistAqiModelAdapter());
  Hive.registerAdapter(TimestampAqiAdapter());
  Hive.registerAdapter(FireModelAdapter());
  Hive.registerAdapter(FireInfoAdapter());

  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: SplashScreen(),
      )
  );
}
