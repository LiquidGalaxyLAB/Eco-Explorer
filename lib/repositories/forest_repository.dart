import 'dart:convert';

import '../models/forests_model.dart';
import '../providers/forest_data_provider.dart';

class ForestRepository{
  final ForestDataProvider forestDataProvider;
  ForestRepository(this.forestDataProvider);

  Future<ForestsModel> getForests() async{
    final forests = await forestDataProvider.getForests();

    final data = jsonDecode(forests);

    return ForestsModel.fromMap(data);
  }
}