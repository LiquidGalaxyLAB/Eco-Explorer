import 'dart:isolate';
import 'dart:ui';

import 'package:eco_explorer/models/fire/fire_model.dart';
import 'package:eco_explorer/models/historical_aqi/hist_aqi_model.dart';
import 'package:eco_explorer/screens/dashboard_screen.dart';
import 'package:eco_explorer/screens/help_screen.dart';
import 'package:eco_explorer/screens/home_screen.dart';
import 'package:eco_explorer/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'models/aqi/aqi_model.dart';

@pragma('vm:entry-point')
  void downloadCallback(String id, int status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

void main() async{

  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  if(mapsImplementation is GoogleMapsFlutterAndroid){
    mapsImplementation.useAndroidViewSurface = true;
  }

  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
      debug: true,
      ignoreSsl: true
  );

  FlutterDownloader.registerCallback(downloadCallback);

  await Hive.initFlutter();
  Hive.registerAdapter(AqiModelAdapter());
  Hive.registerAdapter(HistAqiModelAdapter());
  Hive.registerAdapter(TimestampAqiAdapter());
  Hive.registerAdapter(FireModelAdapter());
  Hive.registerAdapter(FireInfoAdapter());

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: SplashScreen(),
        // initialRoute: '/',
        // routes: {
        //   Routes.splash: (context) => const SplashScreen(),
        //   Routes.home: (context) => const HomeScreen(),
        //   Routes.help: (context) => const HelpScreen(),
        // },
        // onGenerateRoute: (settings) {
        //   final uri = Uri.parse(settings.name ?? '');
        //
        //   if (uri.pathSegments.length == 1) {
        //     final indexString = uri.pathSegments[0];
        //     final index = int.tryParse(indexString);
        //     if (index != null) {
        //       return MaterialPageRoute(
        //         builder: (context) => DashboardScreen(i: index),
        //       );
        //     }
        //   }
        //   return MaterialPageRoute(
        //     builder: (context) => HomeScreen(),
        //   );
        // },
      ),
    )
  );
}
