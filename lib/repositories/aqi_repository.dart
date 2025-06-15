import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/aqi_data_provider.dart';
import '../providers/local/db_provider.dart';
import '../utils/connection/internet_connectivity.dart';

class AqiRepository<M>{
  final DbProvider<M> aqiDbProvider;
  final IAqiDataProvider aqiDataProvider;
  final M Function(Map<String, dynamic>) fromMap;
  AqiRepository(this.aqiDataProvider,this.aqiDbProvider, this.fromMap);

  Future<M> getPollutionData(WidgetRef ref, double lat, double lon) async {

    final bool isConnected = await InternetConnectivity().checkInternetConnection();
    print('$isConnected');

    if(isConnected){
      try{
        final response = await aqiDataProvider.getPollutionData(ref, lat,lon);

        if (response.statusCode == 200) {
          M aqiModel = fromMap(response.data);
          await aqiDbProvider.insertData(post: aqiModel);
          M? cachedAqi = await aqiDbProvider.getData();
          if (cachedAqi != null) {
            return cachedAqi;
          } else {
            throw 'Failed to retrieve cached AQI data.';
          }

        } else {
          return await _loadFromLocal('Unknown Error Happened!');
        }
      }catch(e){
        return await _loadFromLocal('Error in fetching: ${e.toString()}');
      }
    }else{
      return await _loadFromLocal('Can\'t load API');
    }
  }

  Future<M> _loadFromLocal(String e) async {
    final bool isDataAvailable = await aqiDbProvider.isDataAvailable();
    if (isDataAvailable) {
      final M? localSource = await aqiDbProvider.getData();
      if (localSource != null) return localSource;
    }
    throw e;
  }
}