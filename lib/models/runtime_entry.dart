import 'package:hive/hive.dart';

part 'runtime_entry.g.dart';

@HiveType(typeId: 1)
class RuntimeEntry extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String generator;

  @HiveField(2)
  double hours;

  @HiveField(3)
  double rate;

  RuntimeEntry({
    required this.date,
    required this.generator,
    required this.hours,
    required this.rate,
  });
}
