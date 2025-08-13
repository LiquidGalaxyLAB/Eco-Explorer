import 'package:eco_explorer/utils/voice/dashboard_voice_controller.dart';
import 'package:eco_explorer/utils/voice/home_voice_controller.dart';
import 'package:eco_explorer/utils/voice/speech_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/forests_model.dart';
import '../utils/connection/ssh.dart';
import '../utils/voice/map_voice_controller.dart';

final sshProvider = ChangeNotifierProvider<Ssh>((ref) => Ssh());

final forestProvider = StateProvider<Forest?>((ref) => null);

final mapVoiceProvider = NotifierProvider<MapVoiceController, SpeechState>(() => MapVoiceController());
final homeVoiceProvider = NotifierProvider<HomeVoiceController, SpeechState>(() => HomeVoiceController());
final dashboardVoiceProvider = NotifierProvider<DashboardVoiceController, SpeechState>(() => DashboardVoiceController());

