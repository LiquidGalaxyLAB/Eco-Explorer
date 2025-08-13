import 'package:eco_explorer/utils/orbit_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:throttling/throttling.dart';

import '../constants/fonts.dart';
import '../constants/strings.dart';
import '../constants/theme.dart';
import '../ref/instance_provider.dart';
import '../ref/values_provider.dart';
import '../utils/connection/ssh.dart';
import '../utils/voice/map_voice_controller.dart';
import '../utils/voice/speech_controller.dart';
import '../widgets/controller_button.dart';
import '../widgets/snackbar.dart';
import 'help_screen.dart';

class RigController extends ConsumerStatefulWidget {
  final OverlayEntry? entry;
  const RigController({super.key, required this.entry});

  @override
  ConsumerState<RigController> createState() => _RigControllerState();
}

class _RigControllerState extends ConsumerState<RigController> {
  late Ssh ssh;
  late Throttling thr1;
  late Throttling thr2;

  late bool isOrbitPlaying;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    thr1 = Throttling<void>(duration: const Duration(milliseconds: 200));
    thr2 = Throttling<void>(duration: const Duration(milliseconds: 200));
    Future.microtask((){
      ref.read(isOrbitPlayingProvider.notifier).state = false;
    });
  }

  @override
  void dispose() {
    thr1.close();
    thr2.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapVoiceProvider);
    final isListening = state.isListening;

    final controller = ref.read(mapVoiceProvider.notifier);

    double latitude = ref.watch(latitudeProvider)!;
    double longitude = ref.watch(longitudeProvider)!;
    double altitude = ref.watch(altitudeProvider)!;
    double zoom = ref.watch(zoomProvider)!;
    double tilt = ref.watch(tiltProvider)!;
    double heading = ref.watch(headingProvider)!;

    isOrbitPlaying = ref.watch(isOrbitPlayingProvider);

    return PopScope(
        onPopInvoked: (didPop) {
          ref.read(isOrbitPlayingProvider.notifier).state = false;
        },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.75),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () { widget.entry?.remove(); },
            icon: Icon(Icons.close,color: Colors.white,),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Constants.totalHeight(context)*0.15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Rig Controller', style: Fonts.extraBold.copyWith(fontSize: Constants.totalHeight(context)*0.03,color: Colors.white),),
                  SizedBox(width: 0.015*Constants.totalWidth(context),),
                  IconButton(onPressed: (){
                    OverlayEntry? entry;
                    entry = OverlayEntry(
                        builder: (context) =>
                            HelpScreen(entry: entry,)
                    );
                    final overlay = Overlay.of(context);
                    overlay.insert(entry);
                  }, icon: Icon(Icons.help_outline,color: Colors.white,))
                ],
              ),
              SizedBox(height: Constants.totalHeight(context)*0.05,),
              ControllerButton(
                  onPressed: () async => isOrbitPlaying?stopOrbit(latitude, longitude, altitude):playOrbit(latitude, longitude, altitude)
                // playOrbit(ssh, ref, context);
                            ,
                  iconData: isOrbitPlaying?Icons.stop_outlined:Icons.play_arrow_outlined
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ControllerButton(onPressed: () async {
                      double newAlt = (altitude - Constants.zoomStep).clamp(0.0, 1000000.0);

                      await ssh.flyToWithoutSaving(context, ref, latitude, longitude,
                      newAlt, zoom, tilt, heading);

                    },
                        iconData: Icons.zoom_in
                    ),
                    SizedBox(width: Constants.totalWidth(context)*0.15,),
                    ControllerButton(onPressed: () async {
                      double newAlt = (altitude + Constants.zoomStep).clamp(0.0, 1000000.0);

                      await ssh.flyToWithoutSaving(context, ref, latitude, longitude,
                          newAlt, zoom, tilt, heading);
                      },
                        iconData: Icons.zoom_out
                    ),
                  ]
              ),
              ControllerButton(onPressed: () async{
                if (isListening) {
                  await controller.stopListening();
                } else {
                  await controller.startListening(ref, context);
                }
              }, iconData: isListening?Icons.mic_off_outlined:Icons.mic_none),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Joystick(
                          // key: GlobalKey(debugLabel: 'Lat/Long'),
                          stick: Container(
                            height: Constants.totalWidth(context)*0.15,
                            width: Constants.totalWidth(context)*0.15,
                            decoration: BoxDecoration(
                              color: Colors.grey[900]!.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          base: Container(
                            width: Constants.totalWidth(context)*0.35,
                            height: Constants.totalWidth(context)*0.35,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          listener: (details) {
                            thr1.throttle(() async{
                              double newLat = latitude - (details.y * Constants.latStep);
                              double newLon = longitude + (details.x * Constants.lonStep);

                              if (newLat > 90) {
                                newLat = 180 - newLat;
                                newLon = -newLon;
                              }else if (newLat < -90) {
                                newLat = -180 - newLat;
                                newLon = -newLon;
                              }

                              if (newLon > 180) newLon -= 360;
                              if (newLon < -180) newLon += 360;

                              await ssh.flyToWithoutSaving(context, ref, newLat, newLon,
                                  altitude,zoom,tilt,heading);
                            });
                          }
                      ),
                      SizedBox(height: Constants.totalHeight(context)*0.01,),
                      Text('Move', style: Fonts.semiBold.copyWith(color: Colors.white),),
                    ],
                  ),
                  SizedBox(width: Constants.totalWidth(context)*0.02,),
                  Column(
                    children: [
                      Joystick(
                          stick: Container(
                            height: Constants.totalWidth(context)*0.15,
                            width: Constants.totalWidth(context)*0.15,
                            decoration: BoxDecoration(
                              color: Colors.grey[900]!.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          base: Container(
                            width: Constants.totalWidth(context)*0.35,
                            height: Constants.totalWidth(context)*0.35,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          listener: (details) {
                            thr2.throttle(() async{
                              double newTilt = (tilt + (-details.y * Constants.tiltStep)).clamp(0.0, 90.0);
                              double newHeading = (heading + (details.x * Constants.headingStep)) % 360;
                              if (newHeading < 0) newHeading += 360;

                              await ssh.flyToWithoutSaving(context, ref,
                                  latitude, longitude, altitude, zoom, newTilt, newHeading
                              );
                            });
                          }
                      ),
                      SizedBox(height: Constants.totalHeight(context)*0.01,),
                      Text('Tilt/Heading', style: Fonts.semiBold.copyWith(color: Colors.white),),
                    ],
                  ),
                ],
              ),
              // SizedBox(height: Constants.totalHeight(context)*0.05,),
              SizedBox(height: Constants.totalHeight(context)*0.05,),
              Visibility(
                  visible: isListening,
                  replacement: SizedBox(height: Constants.totalHeight(context)*0.2),
                  child: Column(
                    children: [
                      Text((state.lastWords.isEmpty)?'TRANSCRIBED TEXT':state.lastWords,
                        style: Fonts.medium.copyWith(fontSize: Constants.totalHeight(context)*0.025,color: Colors.white),),
                      SizedBox(height: Constants.totalHeight(context)*0.03,),
                      Lottie.asset(
                        height: Constants.totalHeight(context)*0.1,
                        'assets/voice/anim.json',
                        fit: BoxFit.contain,
                        animate: true,
                      ),
                      SizedBox(height: Constants.totalHeight(context)*0.025,),
                      Text('Listening...', style: Fonts.regular.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Colors.white),),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  playOrbit(latitude, longitude, altitude) async{
    ref.read(isOrbitPlayingProvider.notifier).state = true;
    await OrbitController().startOrbit(context, ref, ssh, latitude, longitude, altitude);
    await stopOrbit(latitude, longitude, altitude);
  }
  stopOrbit(latitude, longitude, altitude) async{
    ref.read(isOrbitPlayingProvider.notifier).state = false;
    await OrbitController().stopOrbit(context, ssh, latitude, longitude,altitude);
  }
}

void showOverlay(BuildContext context, Ssh ssh){
  if(ssh.isConnected){
    OverlayEntry? entry;
    entry = OverlayEntry(
        builder: (context) =>
            ProviderScope(
                overrides: [
                  isOrbitPlayingProvider.overrideWith((ref) => false),
                ],
                child: RigController(entry: entry,)
            )
    );
    final overlay = Overlay.of(context);
    overlay.insert(entry);
  }
}


