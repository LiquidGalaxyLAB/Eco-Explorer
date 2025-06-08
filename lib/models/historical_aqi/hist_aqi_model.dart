import 'package:hive/hive.dart';
part 'hist_aqi_model.g.dart';

@HiveType(typeId: 2)
class HistAqiModel extends HiveObject{
  @HiveField(0)
  final List<TimestampAqi> aqis;
  HistAqiModel({required this.aqis});

  factory HistAqiModel.fromMap(Map<String, dynamic> map){
    final data = map['list'] as List;
    final aqis = data.map((e) =>
        TimestampAqi.fromMap(e)).toList();
    return HistAqiModel(aqis: aqis);
  }
}

@HiveType(typeId: 3)
class TimestampAqi{
  @HiveField(0)
  final int timestamp;
  @HiveField(1)
  final double aqi;

  TimestampAqi({required this.timestamp, required this.aqi});

  factory TimestampAqi.fromMap(Map<String, dynamic> map){
    return TimestampAqi(
        timestamp: int.tryParse(map['dt'].toString())??0,
        aqi: double.tryParse(map['main']['aqi'].toString())??0.0
    );
  }
}