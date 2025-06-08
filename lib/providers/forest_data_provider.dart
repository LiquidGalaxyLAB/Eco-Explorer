import 'package:flutter/services.dart';

class ForestDataProvider{
  Future<String> getForests() async{
    return await rootBundle.loadString('assets/forests.json');
  }
}