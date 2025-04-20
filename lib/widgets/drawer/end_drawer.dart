import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/hooks/user/use_current_user.dart';
import 'package:sportmatter/l10n/l10n.dart';

class RightMenu extends HookWidget {
  const RightMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser();
    final roles = user?.roles;

    final width = MediaQuery.of(context).size.width;
    final drawerWidth = width.clamp(280, 880).toDouble();
    final horizontalPadding = width > 1000 ? 32.0 : width > 600 ? 24.0 : 16.0;
    final verticalSpacing = width > 1000 ? 24.0 : width > 600 ? 20.0 : 16.0;

    return Drawer(
      backgroundColor: context.theme.primary,
      child: SizedBox(
        width: drawerWidth,
        child: SafeArea(
          child: SingleChildScrollView( // ✅ přidáno scrollování
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: verticalSpacing / 2),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
                SizedBox(height: verticalSpacing / 2),
                Text(context.l10n.menu, style: context.textTheme.h1),
                SizedBox(height: verticalSpacing / 2),
                const Divider(thickness: 3),
                SizedBox(height: verticalSpacing / 2),

                _MenuItem(
                  title: context.l10n.myMatches,
                  onTap: () => context.router.replace(const HomeRoute()),
                ),
                SizedBox(height: verticalSpacing / 2),

                if (roles!.contains('ROLE_MANAGER') || roles.contains('ROLE_SUPERADMIN')) ...[
                  _MenuItem(
                    title: context.l10n.countries,
                    onTap: () => context.router.replace(const CountryRoute()),
                  ),
                  SizedBox(height: verticalSpacing / 2),
                  _MenuItem(
                    title: context.l10n.teams,
                    onTap: () => context.router.replace(const TeamRoute()),
                  ),
                  SizedBox(height: verticalSpacing / 2),
                  _MenuItem(
                    title: context.l10n.stadiums,
                    onTap: () => context.router.replace(const StadiumRoute()),
                  ),
                  SizedBox(height: verticalSpacing / 2),
                  _MenuItem(
                    title: context.l10n.players,
                    onTap: () => context.router.replace(const PlayerRoute()),
                  ),
                  SizedBox(height: verticalSpacing / 2),
                  _MenuItem(
                    title: context.l10n.referees,
                    onTap: () => context.router.replace(const RefereeRoute()),
                  ),
                  SizedBox(height: verticalSpacing / 2),
                  _MenuItem(
                    title: context.l10n.leagues,
                    onTap: () => context.router.replace(const LeagueRoute()),
                  ),
                  SizedBox(height: verticalSpacing / 2),
                  _MenuItem(
                    title: context.l10n.seasons,
                    onTap: () => context.router.replace(const SeasonRoute()),
                  ),
                  SizedBox(height: verticalSpacing / 2),
                  _MenuItem(
                    title: context.l10n.matches,
                    onTap: () => context.router.replace(const MatchRoute()),
                  ),
                  SizedBox(height: verticalSpacing / 2),
                ],

                if (roles.contains('ROLE_SUPERADMIN')) ...[
                  _MenuItem(
                    title: context.l10n.users,
                    onTap: () => context.router.replace(const UserRoute()),
                  ),
                  SizedBox(height: verticalSpacing / 2),
                ],

                SizedBox(height: verticalSpacing), // místo Spacer kvůli scrollu
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MenuItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: context.textTheme.body),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
    );
  }
}
