// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeneratorAdapter extends TypeAdapter<Generator> {
  @override
  final int typeId = 2;

  @override
  Generator read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Generator(
      name: fields[0] as String,
      code: fields[1] as String,
      tankCapacity: fields[2] as double,
      fuelConsumptionRate: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Generator obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.tankCapacity)
      ..writeByte(3)
      ..write(obj.fuelConsumptionRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneratorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
