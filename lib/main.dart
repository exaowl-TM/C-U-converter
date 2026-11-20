import 'package:flutter/material.dart';

import './data/currency/currency_converter.dart' as currency;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<void> _handleConversion() async {
    try {
      // 2. Call the imported function directly
      double result = await currency.convert('USD', 'JOD', 1);
      debugPrint('Converted amount: $result');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (innerContext) => ElevatedButton(
              onPressed: () => _handleConversion(),
              child: const Text('Convert 50 USD to EUR'),
            ),
          ),
        ),
      ),
    );
  }
}
//main,dart
