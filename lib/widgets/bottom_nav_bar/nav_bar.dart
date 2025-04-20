import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/l10n/l10n.dart';

class BottomNavBar extends StatelessWidget {

  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final iconSize = isWide ? 32.0 : 24.0;

    return Container(
      decoration: BoxDecoration(
        gradient: context.theme.primaryGradient,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (index) {
            // Global routing
            switch (index) {
              case 0:
                context.router.push(const HomeRoute());
              case 1:
               // context.router.push(const ProfileRoute());
                context.router.push(const ProfileRoute());
              case 2:
                context.router.push(const SettingsRoute());
              case 3:
                Scaffold.of(context).openEndDrawer();
            }
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer, size: iconSize),
              label: context.l10n.myMatches,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: iconSize),
              label: context.l10n.profile,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: iconSize),
              label: context.l10n.settings,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu, size: iconSize),
              label: context.l10n.menu,
            ),
          ],
        ),
      ),
    );
  }
}

