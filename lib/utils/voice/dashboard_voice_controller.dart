import 'dart:io';

import 'package:eco_explorer/utils/voice/speech_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/src/consumer.dart';

import '../../constants/theme.dart';
import '../../ref/values_provider.dart';
import '../../screens/help_screen.dart';
import '../../widgets/snackbar.dart';

class DashboardVoiceController extends SpeechController{
  @override
  Future<void> startListening(WidgetRef ref, BuildContext context) async {
    await super.startListening(ref, context);

    print('DashboardVoiceController: Listening started!');
  }

  @override
  Future<void> executeCommand(WidgetRef ref, BuildContext context, String command) async{
    final cmd = command.toUpperCase();

    final handlers = {
      'INFORMATION': () => setHomeIndex(ref, 0),
      'INFO': () => setHomeIndex(ref, 0),
      'BIODIVERSITY': () => setHomeIndex(ref, 1),
      'ENVIRONMENT': () => setHomeIndex(ref, 2),
      'CATASTROPHE': () => setHomeIndex(ref, 3),
      'DISASTER': () => setHomeIndex(ref, 3),
      'BACK':()=>Navigator.pop(context),
      'HELP':()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>HelpScreen())),
      'EXIT':()=>exit(0),
    };

    for(int i =0;i<labels.length;i++){
      handlers[labels[i].toUpperCase()] = (){
        ref.read(mapIndexProvider.notifier).state = i;
      };
    }

    Navigator.pop(context);
    bool matched = false;
    for (final key in handlers.keys) {
      if (cmd.contains(key)) {
        handlers[key]!();
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

  void setHomeIndex(WidgetRef ref, int index) {
    ref.read(dashboardIndexProvider.notifier).state = index;
  }
}