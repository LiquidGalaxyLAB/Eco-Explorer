import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../constants/theme.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.75),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
