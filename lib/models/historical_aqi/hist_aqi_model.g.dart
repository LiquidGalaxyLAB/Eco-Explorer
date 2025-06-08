// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hist_aqi_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistAqiModelAdapter extends TypeAdapter<HistAqiModel> {
  @override
  final int typeId = 2;

  @override
  HistAqiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistAqiModel(
      aqis: (fields[0] as List).cast<TimestampAqi>(),
    );
  }

  @override
  void write(BinaryWriter writer, HistAqiModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.aqis);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistAqiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimestampAqiAdapter extends TypeAdapter<TimestampAqi> {
  @override
  final int typeId = 3;

  @override
  TimestampAqi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimestampAqi(
      timestamp: fields[0] as int,
      aqi: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TimestampAqi obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.aqi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimestampAqiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
