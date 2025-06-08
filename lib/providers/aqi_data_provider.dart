import 'package:dio/dio.dart';

import '../constants/strings.dart';

const apiKey = Constants.openWeatherApiKey;

abstract class IAqiDataProvider {
  Future<Response> getPollutionData(double lat, double lon);
}

class AqiDataProvider implements IAqiDataProvider {
  @override
  Future<Response> getPollutionData(double lat, double lon) async{
    final Dio dio = Dio();

    try{
      String url = 'http://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=${Constants.openWeatherApiKey}';

      final res = await dio.get(url,
      //     queryParameters: {
      //   'lat': lat.toString(),
      //   'lon': lon.toString(),
      //   'appid': apiKey,
      // }
      );

      // print(res.data);
      return res;
    }catch(e){
      print(e);
      throw 'Failed to fetch AQI data: $e';
    }
  }
}

class HistAqiDataProvider implements IAqiDataProvider {
  @override
  Future<Response> getPollutionData(double lat, double lon) async{
    final Dio dio = Dio();

    int getUnixTimestamp(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;

    final DateTime now = DateTime.now();
    final DateTime tenDaysAgo = now.subtract(Duration(days: 10));

    final int end = getUnixTimestamp(now);
    final int start = getUnixTimestamp(tenDaysAgo);

    print('$start $end');

    try{
      print('Fetching AQI data for: lat=$lat, lon=$lon');
      String url = 'http://api.openweathermap.org/data/2.5/air_pollution/history?lat=$lat&lon=$lon&start=$start&end=$end&appid=${Constants.openWeatherApiKey}';

      final res = await dio.get(url,
      //     queryParameters: {
      //   'lat': lat.toString(),
      //   'lon': lon.toString(),
      //   'start': start.toString(),
      //   'end': end.toString(),
      //   'appid': apiKey
      // }
      );

      print(res.data);
      return res;
    }catch (e, stackTrace) {
      if (e is DioException) {
        print('Dio error: ${e.message}');
        print('Response: ${e.response}');
      } else {
        print('Unknown error: $e');
      }
      throw 'Failed to fetch AQI data: $e';
    }
  }
}