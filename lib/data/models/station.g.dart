// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StationAdapter extends TypeAdapter<Station> {
  @override
  final int typeId = 1;

  @override
  Station read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Station(
      stopId: fields[0] as String,
      stopName: fields[1] as String,
      stopLat: fields[2] as double,
      stopLon: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Station obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.stopId)
      ..writeByte(1)
      ..write(obj.stopName)
      ..writeByte(2)
      ..write(obj.stopLat)
      ..writeByte(3)
      ..write(obj.stopLon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
