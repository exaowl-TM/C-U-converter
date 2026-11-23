import 'package:flutter/material.dart';
import 'screens/currency.dart';
import 'screens/unit.dart';

void main() {
  runApp(const ConverterApp());
}

class ConverterApp extends StatefulWidget {
  const ConverterApp({super.key});

  @override
  State<ConverterApp> createState() => _ConverterAppState();
}

class _ConverterAppState extends State<ConverterApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency & Unit Converter',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF66BB6A),
          brightness: Brightness.dark,
        ),
      ),
      home: HomeConverterScreen(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class HomeConverterScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const HomeConverterScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<HomeConverterScreen> createState() => _HomeConverterScreenState();
}

class _HomeConverterScreenState extends State<HomeConverterScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Converter',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Everyday conversions, made simple.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  IconButton.filledTonal(
                    onPressed: widget.onToggleTheme,
                    tooltip: 'Switch Theme',
                    icon: Icon(
                      widget.isDark ? Icons.light_mode : Icons.dark_mode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<int>(
                  style: ButtonStyle(
                    visualDensity: VisualDensity.comfortable,
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  segments: const [
                    ButtonSegment<int>(
                      value: 0,
                      label: Text('Currency'),
                    ),
                    ButtonSegment<int>(
                      value: 1,
                      label: Text('Units'),
                    ),
                  ],
                  selected: {_selectedTabIndex},
                  onSelectionChanged: (Set<int> newSelection) {
                    setState(() {
                      _selectedTabIndex = newSelection.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: IndexedStack(
                  index: _selectedTabIndex,
                  children: const [
                    CurrencyScreen(),
                    UnitScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}