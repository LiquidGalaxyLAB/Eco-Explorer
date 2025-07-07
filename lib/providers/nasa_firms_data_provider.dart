import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/strings.dart';
import '../ref/api_provider.dart';

class NasaFirmsDataProvider{
  Future<Response> getFireData(WidgetRef ref, String country, int range) async {
    final Dio dio = ref.read(dioProvider);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final nasaFirmsApiKey = prefs.getString('nasaFirmsApiKey');

    if(nasaFirmsApiKey == null) throw 'Invalid API Key';

    try{
      String url = 'https://firms.modaps.eosdis.nasa.gov/api/country/csv';

      print('$url/$nasaFirmsApiKey/VIIRS_SNPP_NRT/$country/$range');
      final res = await dio.get(
          '$url/$nasaFirmsApiKey/VIIRS_SNPP_NRT/$country/$range'
      );

      print(res.data);
      return res;
    } catch(e){
      print(e);
      throw 'Failed to fetch fire data: $e';
    }
  }
}