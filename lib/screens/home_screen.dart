import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/property.dart';
import '../widgets/property_card.dart';
import 'add_property_screen.dart';
import 'property_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Box<Property> box;
  List<MapEntry<dynamic, Property>> properties = [];

  @override
  void initState() {
    super.initState();
    box = Hive.box<Property>('properties');
    _loadProperties();
  }

  void _loadProperties() {
    final map = box.toMap();
    properties = map.entries.toList();
    setState(() {});
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

  void _openPropertyDetails(int key, Property property) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PropertyDetailsScreen(propertyKey: key, property: property)),
    );
    if (result == true) {
      _loadProperties();
    }
  }

  double _calculateTotalValue() {
    return properties.fold(0, (sum, entry) => sum + entry.value.totalAmount);
  }

  double _calculatePaidAmount() {
    return properties.fold(0, (sum, entry) => sum + entry.value.paidAmount);
  }

  double _calculateRemainingAmount() {
    return _calculateTotalValue() - _calculatePaidAmount();
  }

  double _calculateTotalArea() {
    return properties.fold(0, (sum, entry) => sum + entry.value.area);
  }

  Map<String, Map<String, int>> _createLocationSummary() {
    Map<String, Map<String, int>> summary = {};
    for (var entry in properties) {
      final property = entry.value;
      summary.putIfAbsent(property.country, () => {});
      summary[property.country]![property.location] =
          (summary[property.country]![property.location] ?? 0) + 1;
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Portfolio'),
        centerTitle: true,
      ),
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
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_work_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No properties found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first property to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        final entry = properties[index];
                        final property = entry.value;
                        return PropertyCard(
                          property: property,
                          onTap: () => _openPropertyDetails(entry.key, property),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewProperty,
        icon: const Icon(Icons.add),
        label: const Text('Add Property'),
      ),
    );
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
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Portfolio Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      context,
                      'Total Value',
                      totalValue,
                      Icons.account_balance,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryCard(
                      context,
                      'Paid Amount',
                      paidAmount,
                      Icons.payments,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      context,
                      'Remaining',
                      remainingAmount,
                      Icons.pending,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryCard(
                      context,
                      'Total Area',
                      totalArea,
                      Icons.square_foot,
                      Colors.purple,
                      isArea: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    double value,
    IconData icon,
    Color color, {
    bool isArea = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isArea
                ? '${value.toStringAsFixed(2)} m²'
                : '\$${NumberFormat('#,##0.00').format(value)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
