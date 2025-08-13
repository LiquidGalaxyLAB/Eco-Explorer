import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/strings.dart';
import '../ref/api_provider.dart';

// const apiKey = Constants.openWeatherApiKey;
// const apiKey = Share;

abstract class IAqiDataProvider {
  Future<Response> getPollutionData(WidgetRef ref, double lat, double lon);
}

class AqiDataProvider implements IAqiDataProvider {
  @override
  Future<Response> getPollutionData(WidgetRef ref, double lat, double lon) async{
    final Dio dio = ref.read(dioProvider);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final openWeatherApiKey = prefs.getString('openWeatherApiKey');

    print(openWeatherApiKey);
    if(openWeatherApiKey == null) throw 'Invalid API Key';

    try{
      String url = 'http://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$openWeatherApiKey';
      print(url);

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
  Future<Response> getPollutionData(WidgetRef ref, double lat, double lon) async{
    final Dio dio = ref.read(dioProvider);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final openWeatherApiKey = prefs.getString('openWeatherApiKey');

    if(openWeatherApiKey == null) throw 'Invalid API Key';

    int getUnixTimestamp(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;

    final DateTime now = DateTime.now();
    final DateTime tenDaysAgo = now.subtract(Duration(days: 10));

    final int end = getUnixTimestamp(now);
    final int start = getUnixTimestamp(tenDaysAgo);


    try{
      String url = 'http://api.openweathermap.org/data/2.5/air_pollution/history?lat=$lat&lon=$lon&start=$start&end=$end&appid=$openWeatherApiKey';

      final res = await dio.get(url,
      //     queryParameters: {
      //   'lat': lat.toString(),
      //   'lon': lon.toString(),
      //   'start': start.toString(),
      //   'end': end.toString(),
      //   'appid': apiKey
      // }
      );
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