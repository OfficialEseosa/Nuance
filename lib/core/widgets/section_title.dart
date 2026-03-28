import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trailingWidgets = switch (trailing) {
      final widget? => <Widget>[widget],
      null => const <Widget>[],
    };

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              if (subtitle case final subtitleText?) ...[
                const SizedBox(height: 2),
                Text(subtitleText, style: theme.textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        ...trailingWidgets,
      ],
    );
  }
}
