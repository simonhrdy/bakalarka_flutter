import 'package:flutter/material.dart';

class ResponsiveRowOrColumn extends StatelessWidget {
  final List<Widget> children;
  final double breakpoint;
  final double spacing;

  const ResponsiveRowOrColumn({
    super.key,
    required this.children,
    this.breakpoint = 1200,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > breakpoint;
    return isWide
        ? Row(
      children: children
          .expand((w) => [Expanded(child: w), SizedBox(width: spacing)])
          .toList()
        ..removeLast(),
    )
        : Column(
      children: children
          .expand((w) => [w, SizedBox(height: spacing)])
          .toList()
        ..removeLast(),
    );
  }
}
