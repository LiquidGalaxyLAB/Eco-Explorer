import 'package:eco_explorer/constants/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/strings.dart';
import '../models/historical_aqi/hist_aqi_model.dart';

class AqiLineChart extends StatefulWidget {
  final List<TimestampAqi> aqis;
  const AqiLineChart({super.key, required this.aqis});

  @override
  State<AqiLineChart> createState() => _AqiLineChartState();
}

class _AqiLineChartState extends State<AqiLineChart> {

  List<ChartData> chartData = [];
  List<FlSpot> plots = [];

  @override
  void initState() {
    super.initState();
    chartData = convertToChartData(widget.aqis);
    for(int i = 0; i < chartData.length; i++){
      plots.add(FlSpot(i.toDouble(), chartData[i].aqi.toDouble()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.75,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
                spots: plots,
                isCurved: true,
                color:Themes.smoothGraph
            ),
          ],
          minY: 1,
          maxY: 5,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameWidget: Text('Dates',style: Fonts.regular.copyWith(color:Themes.cardText,fontSize: Constants.totalWidth(context)*0.03)),
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value,meta){
                  String text = chartData[value.toInt()].label;
                  return SideTitleWidget(
                      meta: meta,
                      child: Text(text,style: Fonts.medium.copyWith(color: Colors.white,fontSize: Constants.totalWidth(context)*0.025),)
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: Text('AQI',style: Fonts.medium.copyWith(color:Themes.cardText,fontSize: Constants.totalWidth(context)*0.03)),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value,meta){
                  return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        value.toInt().toString(),
                        style: Fonts.regular.copyWith(color: Colors.white),
                      )
                  );
                },
                interval: 1,
                reservedSize: 36,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          )
        ),
      ),
    );
  }
}

List<TimestampAqi> filterTimestamps(List<TimestampAqi> aqis) {
  return aqis.where((aqi) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(aqi.timestamp * 1000,isUtc: true);
    return dateTime.hour == DateTime.now().hour && dateTime.minute == 0;
  }).toList();
}

class ChartData {
  final String label;
  final int aqi;

  ChartData(this.label, this.aqi);
}

List<ChartData> convertToChartData(List<TimestampAqi> aqis){
  final List<ChartData> chartData = [];
  final List<TimestampAqi> noonTimestamps = filterTimestamps(aqis);

  for(final aqi in noonTimestamps){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(aqi.timestamp * 1000);
    chartData.add(ChartData('${date.day}/${date.month}', aqi.aqi.toInt()));
  }

  return chartData;
}


