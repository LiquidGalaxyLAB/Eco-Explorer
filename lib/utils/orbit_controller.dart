import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/strings.dart';
import '../ref/values_provider.dart';
import 'connection/ssh.dart';

class OrbitController{

  startOrbit(BuildContext context,WidgetRef ref, Ssh ssh, double lat, double lon, double alt) async{

    await ssh.flyToOrbit(context, lat, lon, alt, Constants.orbitScale, 0, 0);
    await Future.delayed(Duration(seconds: 10));
    for (int i = 0; i <= 360; i += 17) {
      if(!ref.read(isOrbitPlayingProvider)) break;
      await ssh.flyToOrbit(context, lat, lon, alt, Constants.orbitScale, 60, i.toDouble());
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  stopOrbit(BuildContext context, Ssh ssh, double lat, double lon, double alt) async{
    await ssh.flyToOrbit(context, lat, lon, alt, Constants.orbitScale, 0, 0);
  }
}