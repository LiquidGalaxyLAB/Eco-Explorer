import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/forests_model.dart';
import '../utils/connection/ssh.dart';
import '../utils/voice/map_voice_controller.dart';
import '../utils/voice/speech_controller.dart';

final sshProvider = ChangeNotifierProvider<Ssh>((ref) => Ssh());

final forestProvider = StateProvider<Forest?>((ref) => null);

final mapVoiceProvider = NotifierProvider<MapVoiceController, SpeechState>(() => MapVoiceController());
