// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyAdapter extends TypeAdapter<Property> {
  @override
  final int typeId = 0;

  @override
  Property read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Property(
      name: fields[0] as String,
      totalAmount: fields[1] as double,
      paidAmount: fields[2] as double,
      area: fields[3] as double,
      country: fields[4] as String,
      location: fields[5] as String,
      startDate: fields[6] as DateTime,
      endDate: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Property obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.totalAmount)
      ..writeByte(2)
      ..write(obj.paidAmount)
      ..writeByte(3)
      ..write(obj.area)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
