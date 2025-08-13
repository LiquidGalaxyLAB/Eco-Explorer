import 'package:eco_explorer/ref/values_provider.dart';
import 'package:eco_explorer/screens/dashboard_screen.dart';
import 'package:eco_explorer/screens/help_screen.dart';
import 'package:eco_explorer/utils/voice/speech_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/theme.dart';
import '../../ref/instance_provider.dart';
import '../../widgets/snackbar.dart';

class HomeVoiceController extends SpeechController{
  @override
  Future<void> startListening(WidgetRef ref, BuildContext context) async {
    await super.startListening(ref, context);

    print('HomeVoiceController: Listening started!');
  }

  @override
  Future<void> executeCommand(WidgetRef ref, BuildContext context, String command) async {
    final cmd = command.toUpperCase();

    final handlers = {
      'HOME': () => setHomeIndex(ref, 0),
      'API': () => setHomeIndex(ref, 1),
      'PREFERENCES': () => setHomeIndex(ref, 2),
      'SETTINGS': () => setHomeIndex(ref, 2),
      'ABOUT': () => setHomeIndex(ref, 3),
      'HELP':()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>HelpScreen())),
      'EXIT':()=>Navigator.pop(context),
    };

    final forests = ref.read(forestListProvider);
    for(int i =0;i<forests.length;i++){
      handlers[forests[i].path.toUpperCase()] = (){
        ref.read(forestProvider.notifier).state = forests[i];
        Navigator.push(context, MaterialPageRoute(builder: (_)=>DashboardScreen()));
      };
    }

    bool matched = false;
    Navigator.pop(context);
    for (final key in handlers.keys) {
      if (cmd.contains(key)) {
        print('lulu');
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
    ref.read(homeIndexProvider.notifier).state = index;
  }
}
