import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/fonts.dart';
import '../constants/strings.dart';
import '../constants/theme.dart';
import '../ref/instance_provider.dart';

class ConnectionBar extends StatelessWidget {
  final WidgetRef ref;
  const ConnectionBar({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    final connectionStatus = ref.watch(sshProvider).connected;
    return Row(
      children: [
        Icon(Icons.blur_circular,color: connectionStatus?Themes.connected:Themes.disconnected,),
        SizedBox(width: Constants.totalWidth(context)*0.035,),
        Text(connectionStatus?Constants.connected:Constants.disconnected,
          style: Fonts.bold.copyWith(fontSize: Constants.totalWidth(context)*0.035,color: connectionStatus?Themes.connected:Themes.disconnected),
        )
      ],
    );
  }
}