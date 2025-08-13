import 'dart:convert';
import 'dart:io';

import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/utils/kml/balloon_entity.dart';
import 'package:eco_explorer/utils/kml/kml_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/fonts.dart';
import '../constants/theme.dart';
import '../models/deforestation_data_model.dart';
import '../models/forests_model.dart';
import '../ref/instance_provider.dart';
import '../ref/values_provider.dart';
import '../utils/connection/ssh.dart';

class Timelapse extends ConsumerStatefulWidget {
  final Forest forest;
  const Timelapse({super.key, required this.forest});

  @override
  ConsumerState<Timelapse> createState() => _TimelapseState();
}

class _TimelapseState extends ConsumerState<Timelapse> {
  final List<int> yearValues = [2003, 2008, 2013, 2018, 2023];
  double _currentIndex = 0;

  late Ssh ssh;

  @override
  void initState() {
    super.initState();
    ssh = ref.read(sshProvider);
    sendDefoKml();
    ssh.sendKmltoSlave(context, BalloonEntity.forestCoverIndicatorBalloon(widget.forest, Constants.lossImage, 550/2847, Constants.defaultScale, 0, 0,yearValues[0]), Constants.rightRig(ssh.rigCount()));
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text('DEFORESTATION TIMELAPSE',style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Themes.cardText),),
        SizedBox(height: Constants.cardMargin(context),),
        SizedBox(
          width: 0.7*Constants.totalWidth(context),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Themes.logoActive,
              inactiveTrackColor: Colors.grey[700],
              trackHeight: Constants.totalHeight(context) * 0.0125,
              thumbShape: FlatPentagonThumb(thumbSize: Constants.totalHeight(context) * 0.015),
            ),
            child: Slider(
              year2023: false,
              thumbColor: Colors.white,
              value: _currentIndex,
              min: 0,
              max: (yearValues.length - 1).toDouble(),
              divisions: yearValues.length - 1,
              label: yearValues[_currentIndex.round()].toString(),
              onChanged: (double value) async {
                setState(() {
                  _currentIndex = value;
                });
                await sendDefoKml();
              },
            ),
          ),
        ),
        SizedBox(height: Constants.cardMargin(context),),
        Text('Selected Year: ${yearValues[_currentIndex.round()]}',style: Fonts.bold.copyWith(fontSize: Constants.totalHeight(context)*0.02,color: Themes.cardText),),
      ],
    );
  }

  sendDefoKml() async{
    String filename = '${widget.forest.path}_deforestation_$_currentIndex.kml';

    final res = jsonDecode(await rootBundle.loadString('assets/deforestation.json'));
    final data = res['data'];
    DeforestationDataModel model = DeforestationDataModel.fromJson(data, widget.forest.path, yearValues[_currentIndex.round()]);
    File? file = await ssh.makeFile(Constants.filename, await KmlEntity.getDeforestationKml(
        model, yearValues[_currentIndex.round()], widget.forest));
    print("File created");
    await ssh.kmlFileUpload(file!,filename);
    print("Uploaded");
    await ssh.sendKml(context, filename);
    print("Kml sent ");
    ssh.sendKmltoSlave(context, BalloonEntity.forestCoverIndicatorBalloon(widget.forest, Constants.lossImage, 550/2847, Constants.defaultScale, 0, 0,yearValues[_currentIndex.round()]), Constants.rightRig(ssh.rigCount()));
    await ssh.flyToWithoutSaving(context, ref, widget.forest.lat, widget.forest.lon, Constants.forestAltitude, Constants.orbitScale, 0, 0);
  }
}



class FlatPentagonThumb extends SliderComponentShape {
  final double thumbSize;

  FlatPentagonThumb({this.thumbSize = 30.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbSize, thumbSize);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required Size sizeWithOverflow,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double textScaleFactor,
        required double value,
      }) {
    final Canvas canvas = context.canvas;
    Paint paint = Paint()..color = Colors.white;

    double halfSize = thumbSize / 2;
    double squareHeight = thumbSize * 0.8;

    List<Offset> pentagonPoints = [
      Offset(center.dx, center.dy - halfSize),
      Offset(center.dx - halfSize, center.dy),
      Offset(center.dx + halfSize, center.dy),
      Offset(center.dx + halfSize, center.dy + squareHeight),
      Offset(center.dx - halfSize, center.dy + squareHeight),
    ];

    Path pentagon = Path()
      ..moveTo(pentagonPoints[0].dx, pentagonPoints[0].dy)
      ..lineTo(pentagonPoints[1].dx, pentagonPoints[1].dy)
      ..lineTo(pentagonPoints[4].dx, pentagonPoints[4].dy)
      ..lineTo(pentagonPoints[3].dx, pentagonPoints[3].dy)
      ..lineTo(pentagonPoints[2].dx, pentagonPoints[2].dy)
      ..close();

    canvas.drawPath(pentagon, paint);
  }
}
