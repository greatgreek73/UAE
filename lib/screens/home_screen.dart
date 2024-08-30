import 'package:flutter/material.dart';
import '../models/property.dart';
import '../services/database_service.dart';
import 'add_property_screen.dart';
import 'property_details_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
    try {
      final loadedProperties = await DatabaseService.instance.getAllProperties();
      print('Loaded properties: ${loadedProperties.length}'); // Debug print
      for (var property in loadedProperties) {
        print('Property: ${property.name}, Total: ${property.totalAmount}'); // Debug print
      }
      setState(() {
        properties = loadedProperties;
      });
    } catch (e) {
      print('Error loading properties: $e'); // Debug print
    }
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
    print('Building HomeScreen. Properties count: ${properties.length}'); // Debug print
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: InvestmentSummaryWidget(
                totalValue: _calculateTotalValue(),
                paidAmount: _calculatePaidAmount(),
                remainingAmount: _calculateRemainingAmount(),
                totalArea: _calculateTotalArea(),
                locationSummary: _createLocationSummary(),
              ),
            ),
            Expanded(
              flex: 2,
              child: properties.isEmpty
                  ? const Center(child: Text('No properties found. Add some!'))
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _addNewProperty,
      ),
    );
  }

  double _calculateTotalValue() {
    return properties.fold(0, (sum, property) => sum + property.totalAmount);
  }

  double _calculatePaidAmount() {
    return properties.fold(0, (sum, property) => sum + property.paidAmount);
  }

  double _calculateRemainingAmount() {
    return _calculateTotalValue() - _calculatePaidAmount();
  }

  double _calculateTotalArea() {
    return properties.fold(0, (sum, property) => sum + property.area);
  }

  Map<String, Map<String, int>> _createLocationSummary() {
    Map<String, Map<String, int>> summary = {};
    for (var property in properties) {
      summary.putIfAbsent(property.country, () => {});
      summary[property.country]![property.location] = 
          (summary[property.country]![property.location] ?? 0) + 1;
    }
    return summary;
  }
}

class InvestmentSummaryWidget extends StatelessWidget {
  final double totalValue;
  final double paidAmount;
  final double remainingAmount;
  final double totalArea;
  final Map<String, Map<String, int>> locationSummary;

  const InvestmentSummaryWidget({
    Key? key,
    required this.totalValue,
    required this.paidAmount,
    required this.remainingAmount,
    required this.totalArea,
    required this.locationSummary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Investment Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Total Value', '\$${totalValue.toStringAsFixed(2)}'),
          _buildSummaryRow('Paid Amount', '\$${paidAmount.toStringAsFixed(2)}'),
          _buildSummaryRow('Remaining Amount', '\$${remainingAmount.toStringAsFixed(2)}'),
          _buildSummaryRow('Total Area', '${totalArea.toStringAsFixed(2)} m²'),
          const SizedBox(height: 16),
          Text(
            'Location Summary',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...locationSummary.entries.map((entry) => _buildLocationSummary(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLocationSummary(String country, Map<String, int> locations) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(country, style: const TextStyle(fontWeight: FontWeight.bold)),
          ...locations.entries.map((location) => Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text('${location.key}: ${location.value}'),
              )),
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Total: \$${property.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 4),
              Text(
                'Paid: \$${property.paidAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              Text(
                'Area: ${property.area.toStringAsFixed(2)} m²',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Location: ${property.location}, ${property.country}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start: ${_formatDate(property.startDate)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    'End: ${_formatDate(property.endDate)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
    return DateFormat('yyyy-MM-dd').format(date);
  }
}