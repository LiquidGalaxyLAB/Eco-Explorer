import 'package:eco_explorer/screens/dashboard_screen.dart';
import 'package:eco_explorer/widgets/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/fonts.dart';
import '../constants/strings.dart';
import '../models/forests_model.dart';
import '../ref/instance_provider.dart';

class ForestElement extends ConsumerStatefulWidget {
  final Forest forest;
  final int index;
  const ForestElement({super.key, required this.forest, required this.index});

  @override
  ConsumerState<ForestElement> createState() => _ForestElementState();
}

class _ForestElementState extends ConsumerState<ForestElement> {
  
  @override
  Widget build(BuildContext context) {

    Forest forest = widget.forest;
    // double value = (aqi <= 300)? (aqi/300) : 1;
    // double circleSize = Constants.totalHeight(context)*0.1;
    return GestureDetector(
        onTap: () {
          ref.read(forestProvider.notifier).state = forest;
          Navigator.push(context, MaterialPageRoute(builder: (_)=>DashboardScreen()));
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(Constants.cardRadius(context)))),
                // depth: Constants.totalHeight(context)*0.007,
                  intensity: 0.75,
                lightSource: LightSource.bottomRight,
                shadowLightColor: Colors.white.withOpacity(0.6)
              ),
              child: Container(
                width: Constants.totalWidth(context)*0.9,
                height: Constants.totalHeight(context)*0.125,
                padding: EdgeInsets.all(
                  Constants.homeCardPadding(context),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(Constants.cardRadius(context))),
                    // boxShadow: [BoxShadow(
                    //     color: Colors.white.withOpacity(0.2),
                    //     offset: Offset(7, 9),
                    //     spreadRadius: -2,
                    //     blurRadius: 5
                    // )],
                  // color: Colors.black,
                  image: DecorationImage(image: AssetImage('${Constants.home}/${forest.path}.png'), fit: BoxFit.cover)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constants.cardPadding(context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Constants.totalWidth(context)*0.275,
                        child: Text(forest.name, style: Fonts.bold
                          .copyWith(
                            fontSize: Constants.totalHeight(context)*0.019, color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius:7.5,
                              color: Colors.black,
                            )
                          ]
                        )
                          ,maxLines: 2,),
                      ),
                      // SizedBox(width: Constants.totalWidth(context)*0.07,),
                      Container(
                        height: Constants.totalHeight(context)*0.04,
                        width: 1,
                        color: Colors.white,
                      ),
                      // SizedBox(width: Constants.totalWidth(context)*0.01,),
                      SizedBox(
                        height: Constants.totalHeight(context)*0.04,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Area: ${forest.area} km. sq.',style: Fonts.bold.copyWith(
                                  fontSize: Constants.totalHeight(context)*0.009, color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius:7.5,
                                      color: Colors.black,
                                    )
                                  ]
                              ),
                              ),
                              Text('Latitude: ${forest.lat}.',style: Fonts.bold.copyWith(
                                  fontSize: Constants.totalHeight(context)*0.009, color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius:7.5,
                                      color: Colors.black,
                                    )
                                  ]
                              )),
                              Text('Longitude: ${forest.lon}',style: Fonts.bold.copyWith(
                                  fontSize: Constants.totalHeight(context)*0.009, color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius:7.5,
                                      color: Colors.black,
                                    )
                                  ]
                              )),
                            ]
                        ),
                      ),
                      SizedBox(
                        width: Constants.totalHeight(context)*0.07,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset('${Constants.continents}/${forest.continent}.png' ,)
                            ]
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: circleSize,
            //   width: circleSize,
            //   child: Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       CircularProgressIndicator(value: value, color: aqiColor(aqi),strokeWidth: 5,),
            //       Text('AQI',style: Fonts.bold.copyWith(fontSize: 10),)
            //     ],
            //   ),
            // )
          ],
        )
    );
  }
}

