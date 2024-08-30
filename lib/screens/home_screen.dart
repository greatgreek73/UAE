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

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final loadedProperties = await DatabaseService.instance.getAllProperties();
    setState(() {
      properties = loadedProperties;
    });
  }

  void _addNewProperty() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPropertyScreen()),
    );
    if (result == true) {
      _loadProperties();
    }
  }

  void _openPropertyDetails(Property property) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PropertyDetailsScreen(property: property)),
    );
    if (result == true) {
      _loadProperties();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Property Investment Tracker'),
      ),
      body: properties.isEmpty
          ? Center(child: Text('No properties found. Add some!'))
          : ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return PropertyCard(
                  property: property,
                  onTap: () => _openPropertyDetails(property),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewProperty,
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const PropertyCard({Key? key, required this.property, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Total: \$${property.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start: ${_formatDate(property.startDate)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'End: ${_formatDate(property.endDate)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}