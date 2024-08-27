import 'package:flutter/material.dart';
import '../models/property.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';
import 'edit_property_screen.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Property property;

  PropertyDetailsScreen({required this.property});

  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  late Property _property;

  @override
  void initState() {
    super.initState();
    _property = widget.property;
  }

  Future<void> _editProperty() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPropertyScreen(property: _property),
      ),
    );
    if (result == true) {
      // Reload the property details
      final updatedProperty = await DatabaseService.instance.getProperty(_property.id!);
      if (updatedProperty != null) {
        setState(() {
          _property = updatedProperty;
        });
      }
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
      await DatabaseService.instance.deleteProperty(_property.id!);
      Navigator.of(context).pop(true); // Return to home screen
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
            Text('Start Date: ${DateFormat('yyyy-MM-dd').format(_property.startDate)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('End Date: ${DateFormat('yyyy-MM-dd').format(_property.endDate)}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}