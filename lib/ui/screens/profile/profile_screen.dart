import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/hooks/logout/use_logout.dart';
import 'package:sportmatter/hooks/user/use_current_user.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/widgets/button/button.dart';


@RoutePage()
class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth > 800 ? 600.0 : 350.0;

    final currentUser = useCurrentUser();
    final name = currentUser?.name;

    final logout = useLogout(() {
      context.router.replaceAll([const LoginRoute()]);
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: screenWidth,
        height: context.mq.size.height,
        decoration: BoxDecoration(
          gradient: context.theme.primaryGradient,
        ),
        child: Center(
          child: Container(
            width: containerWidth,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.theme.primary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 16),

                Text(name!, style: context.textTheme.body),
                const SizedBox(height: 32),

                PrimaryButton(
                  text: context.l10n.changePassword,
                  onPressed: () {
                    context.router.push(const ResetPasswordRoute());
                  },
                  isDisabled: false,
                ),
                const SizedBox(height: 12),

                PrimaryButton(
                  text: context.l10n.logout,
                  onPressed: logout,
                  isDisabled: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
