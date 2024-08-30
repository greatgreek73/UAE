class Property {
  final int? id;
  final String name;
  final double totalAmount;
  final DateTime startDate;
  final DateTime endDate;
  final double paidAmount;
  final double area;
  final String country;
  final String location;

  Property({
    this.id,
    required this.name,
    required this.totalAmount,
    required this.startDate,
    required this.endDate,
    required this.paidAmount,
    required this.area,
    required this.country,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'totalAmount': totalAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'paidAmount': paidAmount,
      'area': area,
      'country': country,
      'location': location,
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'],
      name: map['name'] ?? '',
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      startDate: DateTime.parse(map['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(map['endDate'] ?? DateTime.now().toIso8601String()),
      paidAmount: map['paidAmount']?.toDouble() ?? 0.0,
      area: map['area']?.toDouble() ?? 0.0,
      country: map['country'] ?? '',
      location: map['location'] ?? '',
    );
  }
}