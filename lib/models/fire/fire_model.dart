import 'package:csv/csv.dart';
import 'package:hive/hive.dart';
part 'fire_model.g.dart';

@HiveType(typeId: 4)
class FireModel extends HiveObject{
  @HiveField(0)
  List<FireInfo> fires;

  FireModel({required this.fires});

  factory FireModel.fromCsv(String csv){

    List<List<dynamic>> data = CsvToListConverter().convert(csv,eol: '\n');
    List<FireInfo> fires = [];

    for (int i = 1; i < data.length; i++) {
      try {
        print('Parsed fire: ${data[i]}');
        fires.add(
          FireInfo(
            lat: double.parse(data[i][1].toString()),
            lon: double.parse(data[i][2].toString()),
            bright_ti4: double.parse(data[i][3].toString()),
            bright_ti5: double.parse(data[i][12].toString()),
            dayNight: data[i][14].toString(),
          ),
        );
      } catch (e) {
        print('Skipping row $i due to error: $e');
      }
    }

    return FireModel(fires: fires);
  }
}

@HiveType(typeId: 5)
class FireInfo extends HiveObject{
  @HiveField(0)
  double lat;
  @HiveField(1)
  double lon;
  @HiveField(2)
  double bright_ti4;
  @HiveField(3)
  double bright_ti5;
  @HiveField(4)
  String instrument = 'VIIRS';
  @HiveField(5)
  String dayNight;

  FireInfo({required this.lat, required this.lon, required this.bright_ti4, required this.bright_ti5, required this.dayNight});
}