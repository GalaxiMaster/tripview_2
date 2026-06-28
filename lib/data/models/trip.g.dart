// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserTripAdapter extends TypeAdapter<UserTrip> {
  @override
  final int typeId = 0;

  @override
  UserTrip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserTrip(
      start: fields[0] as Station?,
      end: fields[1] as Station?,
    );
  }

  @override
  void write(BinaryWriter writer, UserTrip obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
