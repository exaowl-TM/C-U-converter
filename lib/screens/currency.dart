import 'package:flutter/material.dart';
import '../widgets/converter_widgets.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final Map<String, String> _currencyNames = const {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'JOD': 'Jordanian Dinar',
    'SAR': 'Saudi Riyal',
    'GBP': 'British Pound',
  };

  final Map<String, double> _usdRates = const {
    'USD': 1.0,
    'EUR': 0.92,
    'JOD': 0.709,
    'SAR': 3.75,
    'GBP': 0.79,
  };

  String _fromCode = 'USD';
  String _toCode = 'EUR';
  String _inputText = '100';

  double get _rateFromTo {
    final fromRate = _usdRates[_fromCode] ?? 1.0;
    final toRate = _usdRates[_toCode] ?? 1.0;
    return toRate / fromRate;
  }

  String get _convertedResultText {
    final amount = double.tryParse(_inputText) ?? 0.0;
    final result = amount * _rateFromTo;
    return result.toStringAsFixed(2);
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

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCode;
      _fromCode = _toCode;
      _toCode = temp;
    });
  }

  Future<void> _pickCurrency({required bool isFrom}) async {
    final codes = _currencyNames.keys.toList();
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return ListView.builder(
          itemCount: codes.length,
          itemBuilder: (context, index) {
            final code = codes[index];
            return ListTile(
              title: Text(_currencyNames[code] ?? code),
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
          _fromCode = picked;
        } else {
          _toCode = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Currency',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            TextButton.icon(
              onPressed: _swapCurrencies,
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
          selectedTitle: _currencyNames[_fromCode] ?? _fromCode,
          subtitleCode: _fromCode,
          valueText: _inputText,
          isResultCard: false,
          onSelectTap: () => _pickCurrency(isFrom: true),
        ),
        const SizedBox(height: 10),
        ConversionCard(
          headerLabel: 'To',
          selectedTitle: _currencyNames[_toCode] ?? _toCode,
          subtitleCode: _toCode,
          valueText: _convertedResultText,
          isResultCard: true,
          onSelectTap: () => _pickCurrency(isFrom: false),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '1 $_fromCode = ${_rateFromTo.toStringAsFixed(4)} $_toCode · Live/Cached Rate',
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