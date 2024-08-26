import 'package:flutter/material.dart';
import '../models/property.dart';
import '../services/database_service.dart';

class AddPropertyScreen extends StatefulWidget {
  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _totalAmount = 0;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 365));

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final property = Property(
        name: _name,
        totalAmount: _totalAmount,
        startDate: _startDate,
        endDate: _endDate,
      );
      await DatabaseService.instance.createProperty(property);
      Navigator.pop(context, true); // Return true to indicate a new property was added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Property')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Property Name'),
              validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Total Amount'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter an amount' : null,
              onSaved: (value) => _totalAmount = double.parse(value!),
            ),
            // Add date pickers for start and end dates here
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Add Property'),
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }
}