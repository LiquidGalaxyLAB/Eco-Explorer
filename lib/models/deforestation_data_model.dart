import 'dart:convert';

class DeforestationDataModel{
  final List<String> files;
  final List<int> magnitudes;

  DeforestationDataModel({required this.files, required this.magnitudes});

  factory DeforestationDataModel.fromJson(Map<String, dynamic> json, String forest, int year) {

    final forestData = json[forest];
    final files = (forestData['files'] as List).map((e)=>e.toString()).toList();
    final magnitudes = (forestData['magnitudes']['$year'] as List).map((e)=>int.parse(e.toString())).toList();

    return DeforestationDataModel(files: files, magnitudes: magnitudes);
  }
}