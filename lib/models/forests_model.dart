
class ForestsModel{
  List<Forest> forests;

  ForestsModel({required this.forests});

  factory ForestsModel.fromMap(Map<String, dynamic> json){
    final data = json['forests'];
    List<Forest> forests= (data as List).map((e) => Forest.fromMap(e)).toList();
    return ForestsModel(
        forests: forests
    );
  }
}

class Forest {
  final String name;
  final String path;
  final int area;
  final String desc;
  final double max_lat;
  final double min_lat;
  final double max_lon;
  final double min_lon;
  final double lat;
  final double lon;
  final String continent;
  final String ecosystem;
  final List<Species> biodiv;

  Forest(this.ecosystem, this.biodiv, this.name, this.path, this.area,
      this.desc, this.max_lat,
      this.min_lat, this.max_lon, this.min_lon, this.lat, this.lon,
      this.continent);

  factory Forest.fromMap(Map<String, dynamic> json) {
    final species = json['biodiv'] as List;
    List<Species> biodiv = species.map((e) => Species.fromMap(e)).toList();

    return Forest(
      json['ecosystem'] ?? '',
      biodiv,
      json['name'] ?? '',
      json['path'] ?? '',
      int.tryParse(json['area'].toString()) ?? 0,
      json['desc'] ?? '',
      double.tryParse(json['max_lat'].toString()) ?? 0.0,
      double.tryParse(json['min_lat'].toString()) ?? 0.0,
      double.tryParse(json['max_lon'].toString()) ?? 0.0,
      double.tryParse(json['min_lon'].toString()) ?? 0.0,
      double.tryParse(json['lat'].toString()) ?? 0.0,
      double.tryParse(json['long'].toString()) ?? 0.0,
      json['continent'] ?? '',
    );
  }

}

class Species{
  final String name;
  final String sci_name;
  final String img_link;

  Species({required this.name, required this.sci_name, required this.img_link});

  factory Species.fromMap(Map<String, dynamic> json){
    return Species(
        name: json['name'] ?? '',
        sci_name: json['sci_name'] ?? '',
        img_link: json['img_link'] ?? ''
    );
  }
}