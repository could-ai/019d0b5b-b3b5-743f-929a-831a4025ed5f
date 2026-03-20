import 'package:flutter/foundation.dart';

enum SupplierStatus { 
  onboarding, // Initial phase: Contracts & EORI
  pendingTeams, // Handed over to E-commerce & Legal
  completed // All workflows finished
}

class Supplier {
  final String id;
  String name;
  String eoriNumber;
  
  // Onboarding Contracts
  bool ndaSigned;
  bool lfrSigned;
  bool consignmentSigned;
  
  // Team Actions
  bool brandRegistryChecked; // E-commerce
  bool legalDocsUploaded; // Legal (Excel for Declaration of Conformity & GPSR)

  Supplier({
    required this.id,
    required this.name,
    required this.eoriNumber,
    this.ndaSigned = false,
    this.lfrSigned = false,
    this.consignmentSigned = false,
    this.brandRegistryChecked = false,
    this.legalDocsUploaded = false,
  });

  SupplierStatus get status {
    if (!ndaSigned || !lfrSigned || !consignmentSigned || eoriNumber.isEmpty) {
      return SupplierStatus.onboarding;
    }
    if (!brandRegistryChecked || !legalDocsUploaded) {
      return SupplierStatus.pendingTeams;
    }
    return SupplierStatus.completed;
  }
}

class SupplierService extends ChangeNotifier {
  static final SupplierService _instance = SupplierService._internal();
  factory SupplierService() => _instance;
  SupplierService._internal();

  final List<Supplier> _suppliers = [
    // Mock data for demonstration
    Supplier(
      id: '1',
      name: 'Acme Corp',
      eoriNumber: 'GB123456789000',
      ndaSigned: true,
      lfrSigned: true,
      consignmentSigned: true,
      brandRegistryChecked: false,
      legalDocsUploaded: false,
    ),
  ];

  List<Supplier> get suppliers => _suppliers;

  void addSupplier(Supplier supplier) {
    _suppliers.add(supplier);
    notifyListeners();
  }

  void updateSupplier() {
    notifyListeners();
  }
}
