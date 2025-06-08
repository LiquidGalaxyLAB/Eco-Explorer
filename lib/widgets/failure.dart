import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/strings.dart';
import '../constants/theme.dart';

class Failure extends StatelessWidget {
  final String error;
  const Failure({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Icon(Icons.error_outline_outlined,color: Colors.red,size: Constants.totalHeight(context)*0.1,),
            SizedBox(height: Constants.cardMargin(context)/2,),
            Text(
              error,textAlign: TextAlign.center,
              style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Colors.red),
            ),
          ],
        )
    );
  }
}
