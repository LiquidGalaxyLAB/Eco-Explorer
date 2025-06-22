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

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    thr = Throttling<void>(duration: const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {

    bool isListening = false;
    return Scaffold(
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
            ControllerButton(onPressed: (){
            }, iconData: Icons.refresh),
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
            ControllerButton(onPressed: () async{

            }, iconData: isListening?Icons.mic_off_outlined:Icons.mic_none),
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
                          thr.throttle(() async{
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
                    // Text((state.lastWords.isEmpty)?'TRANSCRIBED TEXT':state.lastWords,
                    //   style: Fonts.medium.copyWith(fontSize: Constants.totalHeight(context)*0.025,color: Colors.white),),
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
    );
  }

}


void showOverlay(BuildContext context){
  OverlayEntry? entry;
  entry = OverlayEntry(
      builder: (context) =>
          RigController(entry: entry,)
  );
  final overlay = Overlay.of(context);
  overlay.insert(entry!);
}





