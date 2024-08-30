import 'package:flutter/material.dart';
import '../models/property.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';

class EditPropertyScreen extends StatefulWidget {
  final Property property;

  EditPropertyScreen({required this.property});

  @override
  _EditPropertyScreenState createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _totalAmount;
  late double _paidAmount;
  late double _area;
  late String _country;
  late String _location;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _name = widget.property.name;
    _totalAmount = widget.property.totalAmount;
    _paidAmount = widget.property.paidAmount;
    _area = widget.property.area;
    _country = widget.property.country;
    _location = widget.property.location;
    _startDate = widget.property.startDate;
    _endDate = widget.property.endDate;
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedProperty = Property(
        id: widget.property.id,
        name: _name,
        totalAmount: _totalAmount,
        paidAmount: _paidAmount,
        area: _area,
        country: _country,
        location: _location,
        startDate: _startDate,
        endDate: _endDate,
      );
      await DatabaseService.instance.updateProperty(updatedProperty);
      Navigator.pop(context, updatedProperty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Property')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Property Name'),
              validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              initialValue: _totalAmount.toString(),
              decoration: InputDecoration(labelText: 'Total Amount'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter a total amount' : null,
              onSaved: (value) => _totalAmount = double.parse(value!),
            ),
            TextFormField(
              initialValue: _paidAmount.toString(),
              decoration: InputDecoration(labelText: 'Paid Amount'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter a paid amount' : null,
              onSaved: (value) => _paidAmount = double.parse(value!),
            ),
            TextFormField(
              initialValue: _area.toString(),
              decoration: InputDecoration(labelText: 'Area (m²)'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Please enter an area' : null,
              onSaved: (value) => _area = double.parse(value!),
            ),
            TextFormField(
              initialValue: _country,
              decoration: InputDecoration(labelText: 'Country'),
              validator: (value) => value!.isEmpty ? 'Please enter a country' : null,
              onSaved: (value) => _country = value!,
            ),
            TextFormField(
              initialValue: _location,
              decoration: InputDecoration(labelText: 'Location'),
              validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
              onSaved: (value) => _location = value!,
            ),
            ListTile(
              title: Text('Start Date'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_startDate)),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text('End Date'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_endDate)),
              onTap: () => _selectDate(context, false),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Update Property'),
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }
}