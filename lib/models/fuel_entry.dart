import 'package:hive/hive.dart';

part 'fuel_entry.g.dart';

@HiveType(typeId: 4) // ✅ changed from 1 to 2
class FuelEntry extends HiveObject {
  @HiveField(0)
  String generatorCode;

  @HiveField(1)
  double litres;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String filledBy;

  @HiveField(4)
  double rate;

  FuelEntry({
    required this.generatorCode,
    required this.litres,
    required this.date,
    required this.filledBy,
    required this.rate,
  });
}
