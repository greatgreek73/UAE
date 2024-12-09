import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/property.dart';
import 'package:intl/intl.dart';
import 'edit_property_screen.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final int propertyKey;
  final Property property;

  PropertyDetailsScreen({required this.propertyKey, required this.property});

  @override
  PropertyDetailsScreenState createState() => PropertyDetailsScreenState();
}

class PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  late Property _property;
  late int _propertyKey;
  late Box<Property> box;

  @override
  void initState() {
    super.initState();
    _property = widget.property;
    _propertyKey = widget.propertyKey;
    box = Hive.box<Property>('properties');
  }

  Future<void> _editProperty() async {
    final updatedProperty = await Navigator.push<Property>(
      context,
      MaterialPageRoute(
        builder: (context) => EditPropertyScreen(propertyKey: _propertyKey, property: _property),
      ),
    );
    if (updatedProperty != null) {
      setState(() {
        _property = updatedProperty;
      });
      Navigator.pop(context, true); // Обновление списка на HomeScreen
    }
  }

  Future<void> _deleteProperty() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Property'),
        content: Text('Are you sure you want to delete this property?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await box.delete(_propertyKey);
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_property.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editProperty,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteProperty,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_property.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Total Amount: \$${_property.totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Paid Amount: \$${_property.paidAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Area: ${_property.area.toStringAsFixed(2)} m²', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Country: ${_property.country}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Location: ${_property.location}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Start Date: ${DateFormat('yyyy-MM-dd').format(_property.startDate)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('End Date: ${DateFormat('yyyy-MM-dd').format(_property.endDate)}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
