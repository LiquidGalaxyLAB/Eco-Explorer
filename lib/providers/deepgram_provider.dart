import 'package:audioplayers/audioplayers.dart';
import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/theme.dart';
import '../widgets/snackbar.dart';

class DeepgramProvider{

  final player = AudioPlayer();

  speakFromText(String text,BuildContext context) async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final deepgramApiKey = prefs.getString('deepgramApiKey');

    if(deepgramApiKey == null) throw 'Invalid API Key';

    try{
      Deepgram deepgramTTS = Deepgram(
          deepgramApiKey,
          baseQueryParams: {
            'model': 'aura-asteria-en',
            'encoding': "linear16",
            'container': "wav",
          }
      );

      if(!await deepgramTTS.isApiKeyValid()){
        throw("Invalid API Key");
      }

      final res = await deepgramTTS.speak.text(text);

      if (res.data == null) throw('No audio data found');
      debugPrint('Audio data received: ${res.data?.length} bytes');

      await player.play(BytesSource(res.data!));

    }catch(e){
      showSnackBar(context, e.toString(), Themes.error);
      debugPrint('Deepgram TTS error: $e');
      if (e is PlatformException) {
        debugPrint('Platform error details: ${e.details}');
      }
    }
  }

  stopSpeaking() async{
    await player.stop();
  }

  disposePlayer() async{
    await player.dispose();
  }
}