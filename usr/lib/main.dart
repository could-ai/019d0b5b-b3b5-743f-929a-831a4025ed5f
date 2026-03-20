import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_supplier_screen.dart';
import 'models/supplier_service.dart';

void main() {
  runApp(const SupplierOnboardingApp());
}

class SupplierOnboardingApp extends StatelessWidget {
  const SupplierOnboardingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SupplierService(),
      builder: (context, child) {
        return MaterialApp(
          title: 'Supplier Workflow',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1E88E5),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/add_supplier': (context) => const AddSupplierScreen(),
          },
        );
      },
    );
  }
}
