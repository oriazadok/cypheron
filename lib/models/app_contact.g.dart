// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppContactAdapter extends TypeAdapter<AppContact> {
  @override
  final int typeId = 0;

  @override
  AppContact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppContact(
      name: fields[0] as String,
      phones: (fields[1] as List).cast<String>(),
      messages: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AppContact obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phones)
      ..writeByte(2)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
