import 'package:flutter/material.dart';
import '../models/property.dart';
import '../services/database_service.dart';
import 'add_property_screen.dart';
import 'property_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Property> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    try {
      final loadedProperties = await DatabaseService.instance.getAllProperties();
      setState(() {
        properties = loadedProperties;
        isLoading = false;
      });
      print('Loaded ${properties.length} properties');
    } catch (e) {
      print('Error loading properties: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addNewProperty() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPropertyScreen()),
    );
    if (result == true) {
      _loadProperties(); // Reload the list if a new property was added
    }
  }

  void _openPropertyDetails(Property property) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PropertyDetailsScreen(property: property)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Payment Tracker'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : properties.isEmpty
              ? Center(child: Text('No properties found. Add some!'))
              : ListView.builder(
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return ListTile(
                      title: Text(property.name),
                      subtitle: Text('Total: \$${property.totalAmount.toStringAsFixed(2)}'),
                      onTap: () => _openPropertyDetails(property),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewProperty,
      ),
    );
  }
}