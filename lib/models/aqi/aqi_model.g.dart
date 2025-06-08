// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aqi_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AqiModelAdapter extends TypeAdapter<AqiModel> {
  @override
  final int typeId = 1;

  @override
  AqiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AqiModel(
      aqi: fields[0] as double,
      co: fields[1] as double,
      no: fields[2] as double,
      no2: fields[3] as double,
      o3: fields[4] as double,
      so2: fields[5] as double,
      pm2_5: fields[6] as double,
      pm10: fields[7] as double,
      nh3: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AqiModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.aqi)
      ..writeByte(1)
      ..write(obj.co)
      ..writeByte(2)
      ..write(obj.no)
      ..writeByte(3)
      ..write(obj.no2)
      ..writeByte(4)
      ..write(obj.o3)
      ..writeByte(5)
      ..write(obj.so2)
      ..writeByte(6)
      ..write(obj.pm2_5)
      ..writeByte(7)
      ..write(obj.pm10)
      ..writeByte(8)
      ..write(obj.nh3);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AqiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
