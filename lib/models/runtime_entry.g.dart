// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runtime_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RuntimeEntryAdapter extends TypeAdapter<RuntimeEntry> {
  @override
  final int typeId = 1;

  @override
  RuntimeEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RuntimeEntry(
      date: fields[0] as DateTime,
      generator: fields[1] as String,
      hours: fields[2] as double,
      rate: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RuntimeEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.generator)
      ..writeByte(2)
      ..write(obj.hours)
      ..writeByte(3)
      ..write(obj.rate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RuntimeEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
