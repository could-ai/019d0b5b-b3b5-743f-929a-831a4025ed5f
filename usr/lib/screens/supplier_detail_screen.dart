import 'package:flutter/material.dart';
import '../models/supplier_service.dart';

class SupplierDetailScreen extends StatefulWidget {
  final Supplier supplier;

  const SupplierDetailScreen({super.key, required this.supplier});

  @override
  State<SupplierDetailScreen> createState() => _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen> {
  void _updateState() {
    SupplierService().updateSupplier();
    setState(() {});
  }

  void _simulateExcelUpload() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Uploading and parsing Excel file...'),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close dialog
      widget.supplier.legalDocsUploaded = true;
      _updateState();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item-level compliance documents successfully processed!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPendingTeams = widget.supplier.status == SupplierStatus.pendingTeams || 
                           widget.supplier.status == SupplierStatus.completed;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplier.name),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 24),
            
            if (!isPendingTeams) ...[
              _buildOnboardingWarning(),
              const SizedBox(height: 24),
            ],

            Text(
              'Team Action Points',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // E-commerce Team Section
            _buildEcommerceCard(isEnabled: isPendingTeams),
            const SizedBox(height: 16),
            
            // Legal Team Section
            _buildLegalCard(isEnabled: isPendingTeams),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('EORI Number:', style: TextStyle(color: Colors.grey)),
                Text(
                  widget.supplier.eoriNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text('Contracts Status:', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatusIcon(label: 'NDA', isDone: widget.supplier.ndaSigned),
                _StatusIcon(label: 'LFR', isDone: widget.supplier.lfrSigned),
                _StatusIcon(label: 'Consignment', isDone: widget.supplier.consignmentSigned),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Initial onboarding is incomplete. Ensure all contracts are signed before teams can action.',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcommerceCard({required bool isEnabled}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'E-commerce Team',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Brand Registry in check'),
              subtitle: const Text('Verify the brand registry status for this supplier.'),
              value: widget.supplier.brandRegistryChecked,
              onChanged: isEnabled ? (val) {
                widget.supplier.brandRegistryChecked = val ?? false;
                _updateState();
              } : null,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalCard({required bool isEnabled}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.gavel, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Legal Team',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Item-level compliance requires bulk upload via Excel.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.description, color: Colors.green),
              title: const Text('Declaration of Conformity & GPSR'),
              subtitle: Text(
                widget.supplier.legalDocsUploaded 
                  ? 'Documents uploaded and verified' 
                  : 'Pending Excel upload',
                style: TextStyle(
                  color: widget.supplier.legalDocsUploaded ? Colors.green : Colors.orange,
                ),
              ),
              trailing: widget.supplier.legalDocsUploaded
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : FilledButton.icon(
                      onPressed: isEnabled ? _simulateExcelUpload : null,
                      icon: const Icon(Icons.upload_file, size: 18),
                      label: const Text('Upload Excel'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final String label;
  final bool isDone;

  const _StatusIcon({required this.label, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          isDone ? Icons.check_circle : Icons.cancel,
          color: isDone ? Colors.green : Colors.red,
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
