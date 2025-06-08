import 'package:eco_explorer/constants/theme.dart';
import 'package:eco_explorer/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/strings.dart';
import '../models/forests_model.dart';
import '../utils/connection/ssh.dart';

class ForestElement extends StatefulWidget {
  final Forest forest;
  final int index;
  final Ssh ssh;
  const ForestElement({super.key, required this.forest, required this.index, required this.ssh});

  @override
  State<ForestElement> createState() => _ForestElementState();
}

class _ForestElementState extends State<ForestElement> {
  @override
  Widget build(BuildContext context) {
    // double value = (widget.aqi <= 300)? (widget.aqi/300) : 1;
    // double circleSize = Constants.totalHeight(context)*0.1;
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen(forest: widget.forest,ssh:widget.ssh)));
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: Constants.totalWidth(context)*0.9,
              height: Constants.totalHeight(context)*0.125,
              padding: EdgeInsets.all(
                Constants.homeCardPadding(context),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Constants.cardRadius(context))),
                  boxShadow: [BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      offset: Offset(7, 9),
                      spreadRadius: -2,
                      blurRadius: 5
                  )],
                // color: Colors.black,
                image: DecorationImage(image: AssetImage('${Constants.home}/${widget.forest.path}.png'), fit: BoxFit.cover)
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Constants.cardPadding(context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Constants.totalWidth(context)*0.275,
                      child: Text(widget.forest.name, style: Fonts.bold
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
                            Text('Area: ${widget.forest.area} km. sq.',style: Fonts.bold.copyWith(
                                fontSize: Constants.totalHeight(context)*0.009, color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius:10.0,
                                    color: Colors.white,
                                  )
                                ]
                            ),
                            ),
                            Text('Latitude: ${widget.forest.lat}.',style: Fonts.bold.copyWith(
                                fontSize: Constants.totalHeight(context)*0.009, color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius:10.0,
                                    color: Colors.white,
                                  )
                                ]
                            )),
                            Text('Longitude: ${widget.forest.lon}',style: Fonts.bold.copyWith(
                                fontSize: Constants.totalHeight(context)*0.009, color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius:10.0,
                                    color: Colors.white,
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
                            Image.asset('${Constants.continents}/${widget.forest.continent}.png' ,)
                          ]
                      ),
                    )
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: circleSize,
            //   width: circleSize,
            //   child: Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       CircularProgressIndicator(value: value, color: aqiColor(widget.aqi),strokeWidth: 5,),
            //       Text('AQI',style: Fonts.bold.copyWith(fontSize: 10),)
            //     ],
            //   ),
            // )
          ],
        )
    );
  }
}

