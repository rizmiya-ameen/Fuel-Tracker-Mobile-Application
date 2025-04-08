// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FuelEntryAdapter extends TypeAdapter<FuelEntry> {
  @override
  final int typeId = 4;

  @override
  FuelEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FuelEntry(
      generatorCode: fields[0] as String,
      litres: fields[1] as double,
      date: fields[2] as DateTime,
      filledBy: fields[3] as String,
      rate: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FuelEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.generatorCode)
      ..writeByte(1)
      ..write(obj.litres)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.filledBy)
      ..writeByte(4)
      ..write(obj.rate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuelEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
