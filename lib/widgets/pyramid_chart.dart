import 'package:eco_explorer/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PyramidChart extends StatelessWidget {
  final int aqi;
  PyramidChart({super.key, required this.aqi});

  List<ChartData> chartData = [];

  @override
  Widget build(BuildContext context) {

    for (int i = 1; i <= 5; i++) {
      chartData.add(ChartData(
        category: 'Category $i',
        value: 1,
        color: (i >= aqi) ? aqiColor(aqi.toDouble()) : const Color(0xff323232),
      ));
    }

    return SfPyramidChart(
      series: PyramidSeries<ChartData, String>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.category,
        yValueMapper: (ChartData data, _) => data.value,
        pointColorMapper: (ChartData data, _) => data.color,
        borderColor: Colors.black,
      ),
    );
  }
}

class ChartData{
  final String category;
  final double value;
  final Color color;
  ChartData({required this.category, required this.value, required this.color});
}
