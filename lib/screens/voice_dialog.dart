import 'package:eco_explorer/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../constants/fonts.dart';
import '../constants/theme.dart';
import '../utils/voice/speech_controller.dart';

class VoiceDialog extends ConsumerStatefulWidget {
  final NotifierProvider<SpeechController, SpeechState> provider;
  const VoiceDialog({super.key, required this.provider});

  @override
  ConsumerState<VoiceDialog> createState() => _VoiceDialogState();
}

class _VoiceDialogState extends ConsumerState<VoiceDialog> {

  @override
  void initState() {
    super.initState();
    final controller = ref.read(widget.provider.notifier);
    controller.startListening(ref, context);
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    return Container(
        height: Constants.totalHeight(context)*0.3,
        padding: EdgeInsets.all(Constants.totalWidth(context)*0.05),
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              offset: Offset(0, -4),
              spreadRadius: 5,
              blurRadius: 7
            )
          ]
        ),
        child: Center(
          child: Column(
            children: [
              Lottie.asset(
                  'assets/voice/anim.json',
                  width: Constants.totalWidth(context) * 0.35,
                  height: Constants.totalWidth(context) * 0.35,
                  // fit: BoxFit.contain,
                  animate: true,
                  repeat: true
              ),
              SizedBox(height: Constants.cardMargin(context),),
              Text((state.lastWords.isEmpty)?'Listening...':state.lastWords,
                style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.03,color: Themes.cardText),)
            ],
          ),
        )
    );
  }
}
