import 'package:flutter/material.dart';
import '../models/supplier_service.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  int _currentStep = 0;
  
  // Separate form keys for each step to validate them independently
  final _basicInfoKey = GlobalKey<FormState>();
  final _contractsKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _eoriController = TextEditingController();

  bool _ndaSigned = false;
  bool _lfrSigned = false;
  bool _consignmentSigned = false;

  @override
  void dispose() {
    _nameController.dispose();
    _eoriController.dispose();
    super.dispose();
  }

  void _submit() {
    final newSupplier = Supplier(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      eoriNumber: _eoriController.text,
      ndaSigned: _ndaSigned,
      lfrSigned: _lfrSigned,
      consignmentSigned: _consignmentSigned,
    );

    SupplierService().addSupplier(newSupplier);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Supplier onboarding initiated!')),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboard New Supplier'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_basicInfoKey.currentState!.validate()) {
              setState(() => _currentStep += 1);
            }
          } else if (_currentStep == 1) {
            if (_contractsKey.currentState!.validate()) {
              _submit();
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            Navigator.pop(context);
          }
        },
        controlsBuilder: (context, details) {
          final isLastStep = _currentStep == 1;
          return Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: details.onStepContinue,
                    child: Text(isLastStep ? 'Complete Onboarding' : 'Next'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Basic Information'),
            content: Form(
              key: _basicInfoKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Supplier Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Contracts & EORI'),
            content: Form(
              key: _contractsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _eoriController,
                    decoration: const InputDecoration(
                      labelText: 'EORI Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Confirm the following contracts have been signed:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('NDA (Non-Disclosure Agreement)'),
                    value: _ndaSigned,
                    onChanged: (val) => setState(() => _ndaSigned = val ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('LFR Contract'),
                    value: _lfrSigned,
                    onChanged: (val) => setState(() => _lfrSigned = val ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('Consignment Contract'),
                    value: _consignmentSigned,
                    onChanged: (val) => setState(() => _consignmentSigned = val ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 1,
          ),
        ],
      ),
    );
  }
}
