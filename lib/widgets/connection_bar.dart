import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/strings.dart';
import '../constants/theme.dart';

class ConnectionBar extends StatelessWidget {
  final bool connectionStatus;
  const ConnectionBar({super.key, required this.connectionStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.blur_circular,color: connectionStatus?Themes.connected:Themes.disconnected,),
        SizedBox(width: 15,),
        Text(connectionStatus?Constants.connected:Constants.disconnected,
          style: Fonts.bold.copyWith(fontSize: 15,color: connectionStatus?Themes.connected:Themes.disconnected),
        )
      ],
    );
  }
}
