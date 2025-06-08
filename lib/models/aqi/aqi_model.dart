import 'package:hive/hive.dart';

part 'aqi_model.g.dart';

@HiveType(typeId: 1)
class AqiModel extends HiveObject {
  @HiveField(0)
  final double aqi;

  @HiveField(1)
  final double co;

  @HiveField(2)
  final double no;

  @HiveField(3)
  final double no2;

  @HiveField(4)
  final double o3;

  @HiveField(5)
  final double so2;

  @HiveField(6)
  final double pm2_5;

  @HiveField(7)
  final double pm10;

  @HiveField(8)
  final double nh3;

  AqiModel({
    required this.aqi,
    required this.co,
    required this.no,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.nh3,
  });

  factory AqiModel.fromMap(Map<String, dynamic> map) {
    final data = map['list'][0];
    final components = data['components'];

    double parse(dynamic val) => double.tryParse(val.toString()) ?? 0.0;

    return AqiModel(
      aqi: parse(data['main']['aqi']),
      co: parse(components['co']),
      no: parse(components['no']),
      no2: parse(components['no2']),
      o3: parse(components['o3']),
      so2: parse(components['so2']),
      pm2_5: parse(components['pm2_5']),
      pm10: parse(components['pm10']),
      nh3: parse(components['nh3']),
    );
  }
}
