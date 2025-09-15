// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceLocationHiveAdapter extends TypeAdapter<PlaceLocationHive> {
  @override
  final int typeId = 0;

  @override
  PlaceLocationHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaceLocationHive(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      address: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlaceLocationHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceLocationHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaceHiveAdapter extends TypeAdapter<PlaceHive> {
  @override
  final int typeId = 1;

  @override
  PlaceHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaceHive(
      id: fields[0] as String,
      title: fields[1] as String,
      imagePath: fields[2] as String,
      location: fields[3] as PlaceLocationHive,
    );
  }

  @override
  void write(BinaryWriter writer, PlaceHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
