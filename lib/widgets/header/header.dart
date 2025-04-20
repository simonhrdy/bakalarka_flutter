import 'package:flutter/material.dart';
import 'package:sportmatter/config/extensions/extensions.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final logoHeight= isWide ? 40.0 : 30.0;
    final padding = isWide ? 20.0 : 15.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 16,
      ),
      decoration: BoxDecoration(
          gradient: context.theme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Image.asset(
            'assets/images/logo.png',
            height: logoHeight,
          ),
        ),
      ),
    );
  }
}
