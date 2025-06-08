// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fire_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FireModelAdapter extends TypeAdapter<FireModel> {
  @override
  final int typeId = 4;

  @override
  FireModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FireModel(
      fires: (fields[0] as List).cast<FireInfo>(),
    );
  }

  @override
  void write(BinaryWriter writer, FireModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.fires);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FireModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FireInfoAdapter extends TypeAdapter<FireInfo> {
  @override
  final int typeId = 5;

  @override
  FireInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FireInfo(
      lat: fields[0] as double,
      lon: fields[1] as double,
      bright_ti4: fields[2] as double,
      bright_ti5: fields[3] as double,
      dayNight: fields[5] as String,
    )..instrument = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, FireInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.lon)
      ..writeByte(2)
      ..write(obj.bright_ti4)
      ..writeByte(3)
      ..write(obj.bright_ti5)
      ..writeByte(4)
      ..write(obj.instrument)
      ..writeByte(5)
      ..write(obj.dayNight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FireInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
