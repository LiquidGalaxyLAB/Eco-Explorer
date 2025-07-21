import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechState {
  final String lastWords;
  final String status;
  final bool isListening;

  SpeechState({
    required this.lastWords,
    required this.status,
    required this.isListening,
  });

  SpeechState copyWith({
    String? lastWords,
    String? status,
    bool? isListening,
  }) {
    return SpeechState(
      lastWords: lastWords ?? this.lastWords,
      status: status ?? this.status,
      isListening: isListening ?? this.isListening,
    );
  }
}

abstract class SpeechController extends Notifier<SpeechState> {
  final SpeechToText _speechToText = SpeechToText();

  @override
  SpeechState build() => SpeechState(lastWords: '', status: '', isListening: false);

  Future<void> startListening(WidgetRef ref, BuildContext context,) async{
    print('SpeechController: Listening started!');
    if (_speechToText.isListening || state.isListening) return;
    print('ok');
    if (!state.isListening) {
      final available = await _speechToText.initialize(
        onStatus: (val) {
          print('Speech status: $val');
          state = state.copyWith(status: val);
          if (val == 'notListening') {
            state = state.copyWith(isListening: false);
          }
        },
        onError: (val) => print('Error: $val'),
      );

      if (!available) {
        print("Speech recognition not available");
        state = state.copyWith(status: 'Speech recognition not available');
        return;
      }

      if (available) {
        state = state.copyWith(isListening: true);
        _speechToText.listen(
          onResult: (val) async {
            state = state.copyWith(lastWords: val.recognizedWords);
            if (val.finalResult) {
              await executeCommand(ref, context, val.recognizedWords);
              await stopListening();
            }
          },
        );
      }
    } else {
      await stopListening();
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    state = state.copyWith(isListening: false);
  }

  Future<void> executeCommand(WidgetRef ref, BuildContext context, String command);

}