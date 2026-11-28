import 'package:flutter/material.dart';
import '../widgets/converter_widgets.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({super.key});

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  final Map<String, Map<String, String>> _categoryUnits = const {
    'Length': {
      'cm': 'Centimeter',
      'm': 'Meter',
      'km': 'Kilometer',
    },
    'Weight': {
      'g': 'Gram',
      'kg': 'Kilogram',
      'lb': 'Pound',
    },
    'Time': {
      's': 'Second',
      'min': 'Minute',
      'h': 'Hour',
    },
  };

  final Map<String, Map<String, double>> _toBaseFactor = const {
    'Length': {
      'cm': 0.01,
      'm': 1.0,
      'km': 1000.0,
    },
    'Weight': {
      'g': 0.001,
      'kg': 1.0,
      'lb': 0.45359237,
    },
    'Time': {
      's': 1.0,
      'min': 60.0,
      'h': 3600.0,
    },
  };

  String _selectedCategory = 'Length';
  String _fromUnit = 'cm';
  String _toUnit = 'm';
  String _inputText = '100';

  double get _unitRatio {
    final factors = _toBaseFactor[_selectedCategory]!;
    final fromFactor = factors[_fromUnit] ?? 1.0;
    final toFactor = factors[_toUnit] ?? 1.0;
    return fromFactor / toFactor;
  }

  String get _convertedResultText {
    final value = double.tryParse(_inputText) ?? 0.0;
    final result = value * _unitRatio;
    if (result == result.roundToDouble()) {
      return result.toInt().toString();
    }
    return result.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  void _onKeyPressed(String key) {
    setState(() {
      if (key == '.') {
        if (_inputText.contains('.')) return;
        _inputText = _inputText.isEmpty ? '0.' : '$_inputText.';
        return;
      }
      if (_inputText == '0') {
        _inputText = key;
      } else if (_inputText.length < 12) {
        _inputText += key;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_inputText.length <= 1) {
        _inputText = '0';
      } else {
        _inputText = _inputText.substring(0, _inputText.length - 1);
      }
    });
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });
  }

  Future<void> _pickCategory() async {
    final categories = _categoryUnits.keys.toList();
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return ListTile(
              title: Text(cat),
              onTap: () => Navigator.pop(ctx, cat),
            );
          },
        );
      },
    );

    if (picked != null && picked != _selectedCategory) {
      final keys = _categoryUnits[picked]!.keys.toList();
      setState(() {
        _selectedCategory = picked;
        _fromUnit = keys.first;
        _toUnit = keys.length > 1 ? keys[1] : keys.first;
      });
    }
  }

  Future<void> _pickUnit({required bool isFrom}) async {
    final unitsMap = _categoryUnits[_selectedCategory]!;
    final codes = unitsMap.keys.toList();
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return ListView.builder(
          itemCount: codes.length,
          itemBuilder: (context, index) {
            final code = codes[index];
            return ListTile(
              title: Text(unitsMap[code] ?? code),
              subtitle: Text(code),
              onTap: () => Navigator.pop(ctx, code),
            );
          },
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromUnit = picked;
        } else {
          _toUnit = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final unitsMap = _categoryUnits[_selectedCategory]!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: _pickCategory,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedCategory,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _swapUnits,
              icon: Icon(Icons.swap_vert, size: 18, color: colorScheme.primary),
              label: Text(
                'Swap',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ConversionCard(
          headerLabel: 'From',
          selectedTitle: unitsMap[_fromUnit] ?? _fromUnit,
          subtitleCode: _fromUnit,
          valueText: _inputText,
          isResultCard: false,
          onSelectTap: () => _pickUnit(isFrom: true),
        ),
        const SizedBox(height: 10),
        ConversionCard(
          headerLabel: 'To',
          selectedTitle: unitsMap[_toUnit] ?? _toUnit,
          subtitleCode: _toUnit,
          valueText: _convertedResultText,
          isResultCard: true,
          onSelectTap: () => _pickUnit(isFrom: false),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '1 $_fromUnit = ${_unitRatio.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0+$'), '')} $_toUnit',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        const Spacer(),
        CustomNumericKeypad(
          onKeyPressed: _onKeyPressed,
          onBackspace: _onBackspace,
        ),
      ],
    );
  }
}