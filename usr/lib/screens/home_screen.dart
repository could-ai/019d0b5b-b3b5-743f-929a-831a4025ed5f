import 'package:flutter/material.dart';
import '../models/supplier_service.dart';
import 'supplier_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final suppliers = SupplierService().suppliers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Workflows'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: suppliers.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return _SupplierCard(supplier: supplier);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add_supplier'),
        icon: const Icon(Icons.add),
        label: const Text('Add Supplier'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No suppliers yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          const Text('Tap the button below to start onboarding.'),
        ],
      ),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  final Supplier supplier;

  const _SupplierCard({required this.supplier});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (supplier.status) {
      case SupplierStatus.onboarding:
        statusColor = Colors.orange;
        statusText = 'Onboarding';
        statusIcon = Icons.pending_actions;
        break;
      case SupplierStatus.pendingTeams:
        statusColor = Colors.blue;
        statusText = 'Pending Teams';
        statusIcon = Icons.group_work;
        break;
      case SupplierStatus.completed:
        statusColor = Colors.green;
        statusText = 'Completed';
        statusIcon = Icons.check_circle;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(
          supplier.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('EORI: ${supplier.eoriNumber.isEmpty ? "Pending" : supplier.eoriNumber}'),
        trailing: Chip(
          label: Text(
            statusText,
            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          backgroundColor: statusColor.withOpacity(0.1),
          side: BorderSide.none,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupplierDetailScreen(supplier: supplier),
            ),
          );
        },
      ),
    );
  }
}
