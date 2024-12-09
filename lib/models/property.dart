import 'package:hive/hive.dart';

part 'property.g.dart';

@HiveType(typeId: 0)
class Property {
  @HiveField(0)
  String name;

  @HiveField(1)
  double totalAmount;

  @HiveField(2)
  double paidAmount;

  @HiveField(3)
  double area;

  @HiveField(4)
  String country;

  @HiveField(5)
  String location;

  @HiveField(6)
  DateTime startDate;

  @HiveField(7)
  DateTime endDate;

  Property({
    required this.name,
    required this.totalAmount,
    required this.paidAmount,
    required this.area,
    required this.country,
    required this.location,
    required this.startDate,
    required this.endDate,
  });
}
