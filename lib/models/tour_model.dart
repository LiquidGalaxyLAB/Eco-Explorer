import 'dart:convert';

class TourModel{
  final List<IndividualTour> locations;
  TourModel({required this.locations});

  factory TourModel.fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    final locationList = data['locations'];
    List<IndividualTour> locations =
        (locationList as List).map((location) => IndividualTour.fromJson(location)).toList();

    return TourModel(locations: locations);
  }
}

class IndividualTour{
  final double lat;
  final double lon;
  final String name;
  final String desc;

  IndividualTour({required this.lat, required this.lon, required this.name, required this.desc});

  factory IndividualTour.fromJson(Map<String, dynamic> json){
    return IndividualTour(
        lat: double.tryParse(json['lat'])??0.0,
        lon: double.tryParse(json['lon'])??0.0,
        name: json['name'] ?? '',
        desc: json['desc'] ?? '',
    );
  }
}