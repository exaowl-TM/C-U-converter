import 'package:app_main/screens/currency.dart' as currency;
import 'package:flutter/material.dart';

import 'data/currency/currency_converter.dart' as currency;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<void> _handleConversion() async {
    try {
      // 2. Call the imported function directly
      double result = await currency.convert('USD', 'EUR', 50);
      print('Converted amount: $result');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _handleConversion,
      child: const Text('Convert 50 USD to EUR'),
    );
  }
}
