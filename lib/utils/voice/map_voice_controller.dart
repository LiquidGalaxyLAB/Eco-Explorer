import 'package:eco_explorer/utils/orbit_controller.dart';
import 'package:eco_explorer/utils/voice/speech_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/strings.dart';
import '../../constants/theme.dart';
import '../../ref/instance_provider.dart';
import '../../ref/values_provider.dart';
import '../../widgets/snackbar.dart';
import '../connection/ssh.dart';

class MapVoiceController extends SpeechController{

  @override
  executeCommand(WidgetRef ref, BuildContext context, String command) async {
    final ssh = ref.read(sshProvider);
    final cmd = command.toUpperCase();

    final handlers = {
      'ZOOM IN': () async{
        double newAlt = (ref.read(altitudeProvider)! - Constants.zoomStep).clamp(0.0, 1000000.0);
        await ssh.flyToWithoutSaving(context, ref, ref.read(latitudeProvider)!, ref.read(longitudeProvider)!, newAlt,
            ref.read(zoomProvider)!, ref.read(tiltProvider)!, ref.read(headingProvider)!);
        },
      'ZOOM OUT': () async{
        double newAlt = (ref.read(altitudeProvider)! + Constants.zoomStep).clamp(0.0, 1000000.0);
        await ssh.flyToWithoutSaving(context, ref, ref.read(latitudeProvider)!, ref.read(longitudeProvider)!, newAlt,
            ref.read(zoomProvider)!, ref.read(tiltProvider)!, ref.read(headingProvider)!);
        },
      'MOVE UP': () async{
        double newLat = ref.read(latitudeProvider)!+Constants.latStep;
        if (newLat > 90) {
          newLat = 180 - newLat;
          ref.read(longitudeProvider.notifier).state = -ref.read(longitudeProvider)!;
        }else if (newLat < -90) {
          newLat = -180 - newLat;
          ref.read(longitudeProvider.notifier).state = -ref.read(longitudeProvider)!;
        }

        await ssh.flyToWithoutSaving(context, ref, newLat, ref.read(longitudeProvider)!, ref.read(altitudeProvider)!,
          ref.read(zoomProvider)!, ref.read(tiltProvider)!, ref.read(headingProvider)!);
        },
      'MOVE DOWN': () async{
        double newLat = ref.read(latitudeProvider)!-Constants.latStep;
        if (newLat > 90) {
          newLat = 180 - newLat;
          ref.read(longitudeProvider.notifier).state = -ref.read(longitudeProvider)!;
        }else if (newLat < -90) {
          newLat = -180 - newLat;
          ref.read(longitudeProvider.notifier).state = -ref.read(longitudeProvider)!;
        }

        await ssh.flyToWithoutSaving(context, ref, newLat, ref.read(longitudeProvider)!, ref.read(altitudeProvider)!,
            ref.read(zoomProvider)!, ref.read(tiltProvider)!, ref.read(headingProvider)!);
      },
      'MOVE LEFT': () async{
        double newLon = ref.read(longitudeProvider)!-Constants.lonStep;
        if (newLon > 180) newLon -= 360;
        if (newLon < -180) newLon += 360;

        await ssh.flyToWithoutSaving(context, ref, ref.read(latitudeProvider)!, newLon, ref.read(altitudeProvider)!,
          ref.read(zoomProvider)!, ref.read(tiltProvider)!, ref.read(headingProvider)!);
        },
      'MOVE RIGHT': () async{
        double newLon = ref.read(longitudeProvider)!+Constants.lonStep;
        if (newLon > 180) newLon -= 360;
        if (newLon < -180) newLon += 360;

        await ssh.flyToWithoutSaving(context, ref, ref.read(latitudeProvider)!, newLon, ref.read(altitudeProvider)!,
            ref.read(zoomProvider)!, ref.read(tiltProvider)!, ref.read(headingProvider)!);
      },
      'ORBIT': () async{
        await OrbitController().startOrbit(context, ref, ssh, ref.read(latitudeProvider)!,
            ref.read(longitudeProvider)!, ref.read(altitudeProvider)!);
        await OrbitController().stopOrbit(context, ssh, ref.read(latitudeProvider)!,
            ref.read(longitudeProvider)!, ref.read(altitudeProvider)!);
        // playOrbit(ssh, ref, context);
      },
    };

    bool matched = false;
    for (final key in handlers.keys) {
      if (cmd.contains(key)) {
        await handlers[key]!();
        matched = true;
        break;
      }
    }
    if (!matched) {
      print('Unrecognized command: $cmd');
      showSnackBar(context, 'Unknown voice command',Themes.error);
    }
    state = state.copyWith(lastWords: '');
  }
}

// playOrbit(Ssh ssh, WidgetRef ref, BuildContext context) async{
//   double latitude = ref.watch(latitudeProvider)!;
//   double longitude = ref.watch(longitudeProvider)!;
//   double altitude = ref.watch(altitudeProvider)!;
//   double zoom = ref.watch(zoomProvider)!;
//
//   if(ssh.isConnected == false){
//     showSnackBar(context, 'Not connected to the rig', Themes.error);
//     return;
//   }
//
//   await ssh.flyToWithoutSaving(context, ref, latitude, longitude,
//       altitude, zoom, 0, 0);
//   await Future.delayed(Duration(seconds: 1));
//   for (int i = 0; i <= 360; i += 10) {
//     await ssh.flyToWithoutSaving(context, ref, latitude, longitude,
//         altitude, zoom, 60, i.toDouble());
//     await Future.delayed(const Duration(milliseconds: 500));
//   }
//   await ssh.flyToWithoutSaving(context, ref, latitude, longitude,
//       altitude, zoom, 0, 0);
// }