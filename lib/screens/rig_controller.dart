import 'package:eco_explorer/utils/orbit_controller.dart';
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
import '../utils/orbit_controller.dart';
import '../utils/orbit_controller.dart';
import '../widgets/controller_button.dart';
import '../widgets/snackbar.dart';

class RigController extends ConsumerStatefulWidget {
  final OverlayEntry? entry;
  const RigController({super.key, required this.entry});

  @override
  ConsumerState<RigController> createState() => _RigControllerState();
}

class _RigControllerState extends ConsumerState<RigController> {
  late Ssh ssh;
  late Throttling thr;
  late Throttling thr1;
  late Throttling thr2;

  late bool isOrbitPlaying;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    thr = Throttling<void>(duration: const Duration(milliseconds: 200));
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

    // final state = ref.watch(mapVoiceProvider);
    // final isListening = state.isListening;

    // final controller = ref.read(mapVoiceProvider.notifier);

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
              Text('Rig Controller', style: Fonts.extraBold.copyWith(fontSize: Constants.totalHeight(context)*0.03,color: Colors.white),),
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
                      
                    },
                        iconData: Icons.zoom_in
                    ),
                    SizedBox(width: Constants.totalWidth(context)*0.15,),
                    ControllerButton(onPressed: () async {
                      
                      },
                        iconData: Icons.zoom_out
                    ),
                  ]
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Joystick(
                          key: GlobalKey(debugLabel: 'Lat/Long'),
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


