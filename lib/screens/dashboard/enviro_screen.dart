import 'dart:typed_data';

import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/utils/kml/balloon_entity.dart';
import 'package:eco_explorer/widgets/indicator_bar.dart';
import 'package:eco_explorer/widgets/secondary_button.dart';
import 'package:eco_explorer/widgets/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as image;

import '../../constants/theme.dart';
import '../../models/aqi/aqi_model.dart';
import '../../models/forests_model.dart';
import '../../models/historical_aqi/hist_aqi_model.dart';
import '../../ref/api_provider.dart';
import '../../ref/instance_provider.dart';
import '../../ref/values_provider.dart';
import '../../states/api_state.dart';
import '../../utils/connection/ssh.dart';
import '../../widgets/failure.dart';
import '../../widgets/line_chart.dart';
import 'package:screenshot/screenshot.dart';

import '../../widgets/pyramid_chart.dart';

class EnviroScreen extends ConsumerStatefulWidget {
  EnviroScreen({super.key});

  @override
  ConsumerState<EnviroScreen> createState() => _EnviroScreenState();
}

class _EnviroScreenState extends ConsumerState<EnviroScreen> {

  ScreenshotController imgController = ScreenshotController();

  late Ssh ssh;
  late Forest forest;

  @override
  void initState() {
    super.initState();
    forest = ref.read(forestProvider.notifier).state!;
    ssh = ref.read(sshProvider);

    Future.microtask(() {
      ref.read(aqiNotifierProvider.notifier).fetchAqi(ref, forest.lat, forest.lon);
      ref.read(histAqiNotifierProvider.notifier).fetchHistAqi(ref, forest.lat, forest.lon);
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Color> colors = [good, fair, moderate, poor, veryPoor];
    List<String> indicators = ['Good', 'Fair', 'Moderate', 'Poor', 'Very Poor'];
    List<String> substance = ['CO', 'SO2', 'PM2.5', 'PM10', 'NO2', 'O3'];

    final aqiState = ref.watch(aqiNotifierProvider);
    final histAqiState = ref.watch(histAqiNotifierProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Screenshot(
          controller: imgController,
          child: Column(
            children: [
              aqiState.when(
                  data: (state){
                    if(state is ApiLoading){
                      return Column(
                        children: [
                          ThemeCard(
                              width: Constants.totalWidth(context),
                              child: Center(child: CircularProgressIndicator(color: Themes.cardText),)
                          ),
                          SizedBox(height: 0.5*Constants.cardMargin(context),),
                          ThemeCard(
                              width: Constants.totalWidth(context),
                              child: Center(child: CircularProgressIndicator(color: Themes.cardText),)
                          ),
                        ],
                      );
                    }
                    if(state is ApiSuccess<AqiModel>){
                      final data = state.model;
                      double aqi = data.aqi;

                      List<double> conc = [data.co, data.so2, data.pm2_5, data.pm10, data.no2, data.o3];
                      List<double> max = [15400, 350, 75, 200, 200, 180];

                      return Column(
                        children: [
                          ThemeCard(width: Constants.totalWidth(context),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Air Quality Index',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                                    ],
                                  ),
                                  SizedBox(height: 0.5*Constants.cardMargin(context),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: Constants.totalWidth(context) * 0.4,
                                        height:Constants.totalWidth(context) * 0.4,
                                        child: PyramidChart(aqi: aqi.round()),
                                      ),
                                      SizedBox(
                                        width: Constants.totalWidth(context) * 0.25,
                                        child: Column(
                                          children: List.generate(colors.length, (i) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                bottom: i != colors.length - 1 ? Constants.cardMargin(context) * 0.5 : 0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: Constants.totalHeight(context) * 0.015,
                                                    width: Constants.totalHeight(context) * 0.015,
                                                    decoration: BoxDecoration(
                                                      color: colors[i],
                                                    ),
                                                  ),
                                                  SizedBox(width: Constants.totalWidth(context) * 0.05),
                                                  Text(
                                                    indicators[i],
                                                    style: Fonts.regular.copyWith(
                                                      fontSize: Constants.totalHeight(context) * 0.015,
                                                      color: Themes.cardText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),

                                    ],
                                  )
                                ],
                              )
                          ),
                          SizedBox(height: Constants.cardMargin(context),),
                          ThemeCard(width: Constants.totalWidth(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Concentrations',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                                  SizedBox(height: Constants.cardMargin(context),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 0.175 * Constants.totalWidth(context),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(substance.length, (i) {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom: (i != substance.length - 1) ? 0.5 * Constants.cardMargin(context) : 0),
                                              child: Text(
                                                substance[i].toString(),
                                                style: Fonts.semiBold.copyWith(
                                                  fontSize: 0.05 * Constants.totalWidth(context),
                                                  color: Themes.cardText,
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),

                                      SizedBox(width: 0.5 * Constants.cardMargin(context)),

                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: 0.4 * Constants.totalWidth(context),
                                            minWidth: 0.35 * Constants.totalWidth(context)
                                        ),
                                        child: Column(
                                          children: List.generate(conc.length, (i) {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom: (i != conc.length - 1) ? Constants.cardMargin(context) : 0),
                                              child: IndicatorBar(conc: conc[i], max: max[i]),
                                            );
                                          }),
                                        ),
                                      ),

                                      SizedBox(width: 0.5 * Constants.cardMargin(context)),

                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 0.2 * Constants.totalWidth(context),
                                          minWidth: 0.15 * Constants.totalWidth(context),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(conc.length, (i) {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom: (i != conc.length - 1) ? 0.5 * Constants.cardMargin(context) : 0),
                                              child: Text(
                                                conc[i].toString(),
                                                style: Fonts.medium.copyWith(
                                                  fontSize: 0.05 * Constants.totalWidth(context),
                                                  color: Themes.cardText,
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),

                                    ],
                                  )
                                ],
                              )
                          ),
                        ],
                      );
                    }

                    if(state is ApiFailure){
                      return Column(
                        children: [
                          ThemeCard(
                              width: Constants.totalWidth(context),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Air Quality Index',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                                    ],
                                  ),
                                  SizedBox(height: 0.5*Constants.cardMargin(context),),
                                  Failure(error: state.error),
                                ],
                              )
                          ),
                          SizedBox(height: Constants.cardMargin(context),),
                          ThemeCard(
                              width: Constants.totalWidth(context),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Concentrations',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                                    ],
                                  ),
                                  SizedBox(height: 0.5*Constants.cardMargin(context),),
                                  Failure(error: state.error),
                                ],
                              )
                          ),
                        ],
                      );
                    }
                    return Center();
                  },
                  error: (error, _)=> Column(
                    children: [
                      ThemeCard(
                          width: Constants.totalWidth(context),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Air Quality Index',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                                ],
                              ),
                              SizedBox(height: 0.5*Constants.cardMargin(context),),
                              Failure(error: error.toString()),
                            ],
                          )
                      ),
                      SizedBox(height: Constants.cardMargin(context),),
                      ThemeCard(
                          width: Constants.totalWidth(context),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Concentrations',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                                ],
                              ),
                              SizedBox(height: 0.5*Constants.cardMargin(context),),
                              Failure(error: error.toString()),
                            ],
                          )
                      ),
                    ],
                  ),
                  loading: ()=> Column(
                    children: [
                      ThemeCard(
                          width: Constants.totalWidth(context),
                          child: Center(child: CircularProgressIndicator(color: Themes.cardText),)
                      ),
                      SizedBox(height: 0.5*Constants.cardMargin(context),),
                      ThemeCard(
                          width: Constants.totalWidth(context),
                          child: Center(child: CircularProgressIndicator(color: Themes.cardText),)
                      ),
                    ],
                  )
              ),
              SizedBox(height: Constants.cardMargin(context),),
              ThemeCard(
                  width: Constants.totalWidth(context),
                  child: histAqiState.when(
                      data: (state){
                        if(state is ApiLoading){
                          return Center(child: CircularProgressIndicator(color: Themes.cardText),);
                        }

                        if(state is ApiSuccess<HistAqiModel>){
                          final data = state.model;
                          List<TimestampAqi> aqis = data.aqis;

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text('Historical Data',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                                ],
                              ),
                              SizedBox(height: Constants.cardMargin(context),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: Constants.totalHeight(context) * 0.015,
                                        width: Constants.totalHeight(context) * 0.015,
                                        decoration: BoxDecoration(
                                          color: Themes.graph,
                                        ),
                                      ),
                                      SizedBox(width: Constants.totalWidth(context) * 0.025),
                                      Text(
                                          'Normal Curve',
                                          style: Fonts.regular.copyWith(
                                            fontSize: Constants.totalWidth(context) * 0.025,
                                            color: Themes.cardText,
                                          )
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: Constants.totalHeight(context) * 0.015,
                                        width: Constants.totalHeight(context) * 0.015,
                                        decoration: BoxDecoration(
                                          color: Themes.smoothGraph,
                                        ),
                                      ),
                                      SizedBox(width: Constants.totalWidth(context) * 0.025),
                                      Text(
                                          'Smoothened Curve',
                                          style: Fonts.regular.copyWith(
                                            fontSize: Constants.totalWidth(context) * 0.025,
                                            color: Themes.cardText,
                                          )
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: Constants.cardMargin(context),),
                              ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: Constants.totalHeight(context)),
                                  child: AqiLineChart(aqis: aqis)
                              ),
                            ],
                          );
                        }
                        if(state is ApiFailure){
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text('Historical Data',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                                ],
                              ),
                              SizedBox(height: 0.5*Constants.cardMargin(context),),
                              Failure(error: state.error),
                            ],
                          );
                        }
                        return Center();
                      },
                      error: (error, _)=> Column(
                        children: [
                          Row(
                            children: [
                              Text('Historical Data',style: Fonts.semiBold.copyWith(fontSize: Constants.totalHeight(context)*0.0275,color: Themes.cardText),),
                            ],
                          ),
                          SizedBox(height: 0.5*Constants.cardMargin(context),),
                          Failure(error: error.toString()),
                        ],
                      ),
                      loading: () => Center(child: CircularProgressIndicator(color: Themes.cardText),)
                  )
              ),
            ],
          ),
        ),
        SizedBox(height: Constants.cardMargin(context),),
        SecondaryButton(label: 'Visualize Data', onTap: () async{

          }, icon: Icons.bar_chart,),
      ],
    );
  }


}
