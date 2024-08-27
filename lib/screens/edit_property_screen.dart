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
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _name = widget.property.name;
    _totalAmount = widget.property.totalAmount;
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
              validator: (value) => value!.isEmpty ? 'Please enter an amount' : null,
              onSaved: (value) => _totalAmount = double.parse(value!),
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