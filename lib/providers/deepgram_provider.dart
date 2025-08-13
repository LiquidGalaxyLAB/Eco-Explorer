import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/theme.dart';
import '../widgets/snackbar.dart';

class DeepgramProvider {
  final player = AudioPlayer();
  bool _isStopped = false;

  speakFromText(String text, BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final deepgramApiKey = prefs.getString('deepgramApiKey');

    if (deepgramApiKey == null) throw 'Invalid API Key';

    try {
      if (_isStopped) return;

      Deepgram deepgramTTS = Deepgram(
          deepgramApiKey,
          baseQueryParams: {
            'model': 'aura-asteria-en',
            'encoding': "linear16",
            'container': "wav",
          }
      );

      if (!await deepgramTTS.isApiKeyValid()) {
        throw ("Invalid API Key");
      }

      if (_isStopped) return;

      final res = await deepgramTTS.speak.text(text);

      if (res.data == null) throw ('No audio data found');
      debugPrint('Audio data received: ${res.data?.length} bytes');

      // Final check before playing - this is crucial
      if (_isStopped) return;

      await player.play(BytesSource(res.data!));
    } catch (e) {
      showSnackBar(context, e.toString(), Themes.error);
      debugPrint('Deepgram TTS error: $e');
      if (e is PlatformException) {
        debugPrint('Platform error details: ${e.details}');
      }
    }
  }

  stopSpeaking() async {
    _isStopped = true;
    await player.stop();
  }

  resetState() {
    _isStopped = false;
  }

  disposePlayer() async {
    _isStopped = true;
    await player.dispose();
  }
}