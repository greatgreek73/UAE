import 'package:flutter/material.dart';
import '../models/property.dart';
import 'package:intl/intl.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final Property property;

  PropertyDetailsScreen({required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${property.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Total Amount: \$${property.totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Start Date: ${DateFormat('yyyy-MM-dd').format(property.startDate)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('End Date: ${DateFormat('yyyy-MM-dd').format(property.endDate)}', style: TextStyle(fontSize: 16)),
            // Здесь вы можете добавить больше информации о недвижимости
          ],
        ),
      ),
    );
  }
}