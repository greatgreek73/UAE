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
  double _paidAmount = 0;
  double _area = 0;
  String _country = '';
  String _location = '';
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
        paidAmount: _paidAmount,
        area: _area,
        country: _country,
        location: _location,
      );
      await DatabaseService.instance.createProperty(property);
      Navigator.pop(context, true); // Return true to indicate a new property was added
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
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
              validator: (value) => value!.isEmpty ? 'Please enter a total amount' : null,
              onSaved: (value) => _totalAmount = double.parse(value!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Paid Amount'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter a paid amount' : null,
              onSaved: (value) => _paidAmount = double.parse(value!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Area (m²)'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter an area' : null,
              onSaved: (value) => _area = double.parse(value!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Country'),
              validator: (value) => value!.isEmpty ? 'Please enter a country' : null,
              onSaved: (value) => _country = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Location'),
              validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
              onSaved: (value) => _location = value!,
            ),
            ListTile(
              title: Text('Start Date: ${_startDate.toLocal().toString().split(' ')[0]}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text('End Date: ${_endDate.toLocal().toString().split(' ')[0]}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
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