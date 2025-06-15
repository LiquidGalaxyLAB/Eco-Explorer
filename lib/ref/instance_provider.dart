import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/forests_model.dart';
import '../utils/connection/ssh.dart';

final sshProvider = Provider<Ssh>((ref) => Ssh());

final forestProvider = StateProvider<Forest?>((ref) => null);
