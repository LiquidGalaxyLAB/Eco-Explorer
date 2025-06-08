import 'package:dio/dio.dart';

import '../constants/strings.dart';

class NasaFirmsDataProvider{
  Future<Response> getFireData(String country, int range) async {
    final Dio dio = Dio();
    try{
      String url = 'https://firms.modaps.eosdis.nasa.gov/api/country/csv';
      DateTime today = DateTime.now();

      final res = await dio.get(
          '$url/${Constants.nasaFirmsApiKey}/VIIRS_SNPP_NRT/$country/$range/${today.year}-${today.month}-${today.day}'
      );

      // print(res.data);
      return res;
    } catch(e){
      print(e);
      throw 'Failed to fetch fire data: $e';
    }
  }
}