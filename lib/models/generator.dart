import 'package:hive/hive.dart';

part 'generator.g.dart';

@HiveType(typeId: 2)
class Generator extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String code;

  @HiveField(2)
  final double tankCapacity;

  @HiveField(3)
  final double fuelConsumptionRate; // e.g., litres/hour

  Generator({
    required this.name,
    required this.code,
    required this.tankCapacity,
    required this.fuelConsumptionRate,
  });
}
