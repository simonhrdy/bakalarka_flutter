import 'package:flutter/material.dart';
import 'package:sportmatter/widgets/bottom_nav_bar/nav_bar.dart';
import 'package:sportmatter/widgets/drawer/end_drawer.dart';
import 'package:sportmatter/widgets/header/header.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentPadding = screenWidth >= 1200
        ? const EdgeInsets.fromLTRB(50, 20, 50, 20)
        : EdgeInsets.zero;

    return Scaffold(
      backgroundColor: const Color(0xFF010A0F),
      endDrawer: const RightMenu(),
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Padding(
              padding: contentPadding,
              child: child,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

}
