import 'package:eco_explorer/constants/theme.dart';
import 'package:flutter/material.dart';

import '../constants/strings.dart';

class IndicatorBar extends StatelessWidget {
  final double conc;
  final double max;
  const IndicatorBar({super.key, required this.conc, required this.max});

  @override
  Widget build(BuildContext context) {
    double height = .05*Constants.totalWidth(context);
    double width = 0.4*Constants.totalWidth(context);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: height,
          width: width,
          color: Colors.grey,
        ),
        (conc/max<1)?
        ClipRRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: conc/max,
            child:
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                gradient: gradient
              ),
            )
          ),
        )
              :Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              gradient: gradient
          ),
        ),
      ],
    );
  }
}
