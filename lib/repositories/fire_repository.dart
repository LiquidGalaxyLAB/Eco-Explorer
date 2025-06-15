
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/fire/fire_model.dart';
import '../providers/local/db_provider.dart';
import '../providers/nasa_firms_data_provider.dart';
import '../utils/connection/internet_connectivity.dart';

class FireRepository{
  final DbProvider<FireModel> dbProvider;
  final NasaFirmsDataProvider dataProvider;

  FireRepository(this.dataProvider, this.dbProvider);

  Future<FireModel> getFireData(WidgetRef ref, String country, int range) async {

    final bool isConnected = await InternetConnectivity().checkInternetConnection();

    if(isConnected){
      try{
        final response = await dataProvider.getFireData(ref, country, range);

        if (response.statusCode == 200) {
          FireModel fireModel = FireModel.fromCsv(response.data);
          await dbProvider.insertData(post: fireModel);
          FireModel? cachedModel = await dbProvider.getData();
          if (cachedModel != null) {
            return cachedModel;
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
      return await _loadFromLocal('No Internet Connection');
    }
  }

  Future<FireModel> _loadFromLocal(String e) async {
    final bool isDataAvailable = await dbProvider.isDataAvailable();
    if (isDataAvailable) {
      final FireModel? localSource = await dbProvider.getData();
      if (localSource != null) return localSource;
    }
    throw e;
  }
}