import 'package:flutter/material.dart';

class ConversionCard extends StatelessWidget {
  final String headerLabel;
  final String selectedTitle;
  final String subtitleCode;
  final String valueText;
  final bool isResultCard;
  final VoidCallback onSelectTap;

  const ConversionCard({
    super.key,
    required this.headerLabel,
    required this.selectedTitle,
    required this.subtitleCode,
    required this.valueText,
    required this.isResultCard,
    required this.onSelectTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = isResultCard
        ? colorScheme.secondaryContainer.withValues(alpha: 0.65)
        : colorScheme.surface;
    final borderColor = isResultCard
        ? Colors.transparent
        : colorScheme.outlineVariant;
    final valueColor = isResultCard
        ? colorScheme.primary
        : colorScheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onSelectTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headerLabel,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            selectedTitle,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, size: 20),
                      ],
                    ),
                    Text(
                      subtitleCode,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  valueText,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: valueColor,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomNumericKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onBackspace;

  const CustomNumericKeypad({
    super.key,
    required this.onKeyPressed,
    required this.onBackspace,
  });

  static const List<List<String>> _rows = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    ['.', '0', 'del'],
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: row.asMap().entries.map((entry) {
              final idx = entry.key;
              final keyLabel = entry.value;
              final isDelete = keyLabel == 'del';

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: idx == 0 ? 0 : 4,
                    right: idx == row.length - 1 ? 0 : 4,
                  ),
                  child: SizedBox(
                    height: 52,
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerLow,
                        foregroundColor: colorScheme.onSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if (isDelete) {
                          onBackspace();
                        } else {
                          onKeyPressed(keyLabel);
                        }
                      },
                      child: isDelete
                          ? const Icon(Icons.backspace_outlined, size: 20)
                          : Text(
                              keyLabel,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}