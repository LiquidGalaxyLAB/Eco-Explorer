import 'dart:typed_data';

import 'package:eco_explorer/bloc/hist_aqi_bloc.dart';
import 'package:eco_explorer/constants/fonts.dart';
import 'package:eco_explorer/constants/strings.dart';
import 'package:eco_explorer/events/aqi_event.dart';
import 'package:eco_explorer/events/hist_aqi_event.dart';
import 'package:eco_explorer/utils/kml/balloon_entity.dart';
import 'package:eco_explorer/widgets/secondary_button.dart';
import 'package:eco_explorer/widgets/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/aqi_bloc.dart';
import '../../constants/theme.dart';
import '../../models/aqi/aqi_model.dart';
import '../../models/forests_model.dart';
import '../../models/historical_aqi/hist_aqi_model.dart';
import '../../states/api_state.dart';
import '../../utils/connection/ssh.dart';
import '../../widgets/failure.dart';
import 'package:screenshot/screenshot.dart';

class EnviroScreen extends StatefulWidget {
  final Forest forest;
  final Ssh ssh;
  EnviroScreen({super.key, required this.forest, required this.ssh});

  @override
  State<EnviroScreen> createState() => _EnviroScreenState();
}

class _EnviroScreenState extends State<EnviroScreen> {

  ScreenshotController imgController = ScreenshotController();

  late Ssh ssh;

  @override
  void initState() {
    super.initState();
    context.read<AqiBloc>().add(AqiFetched(lat: widget.forest.lat, lon: widget.forest.lon));
    context.read<HistAqiBloc>().add(HistAqiFetched(lat: widget.forest.lat, lon: widget.forest.lon));
    ssh = widget.ssh;

  }

  @override
  Widget build(BuildContext context) {

    List<Color> colors = [good, fair, moderate, poor, veryPoor];
    List<String> indicators = ['Good', 'Fair', 'Moderate', 'Poor', 'Very Poor'];

    List<String> substance = ['CO', 'SO2', 'PM2.5', 'PM10', 'NO2', 'O3'];

    return Column(
    );
  }


}
