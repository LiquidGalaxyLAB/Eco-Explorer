import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../constants/theme.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.totalHeight(context),
      width: Constants.totalWidth(context),
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: Themes.cardText,),
            SizedBox(height: Constants.totalHeight(context)*0.05,),
            Text('Loading...',style: TextStyle(color: Themes.cardText),)
          ],
        ),
      ),
    );
  }
}
