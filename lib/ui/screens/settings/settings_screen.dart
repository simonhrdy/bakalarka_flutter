import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sportmatter/app.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/l10n/l10n.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLang = Localizations.localeOf(context).languageCode;
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth > 800 ? 600.0 : 350.0;

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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.theme.primary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            width: containerWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.settings,
                  style: context.textTheme.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                Text(l10n.language, style: context.textTheme.body),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: context.theme.primary,
                      value: currentLang,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English', style: context.textTheme.body),
                        ),
                        DropdownMenuItem(
                          value: 'cs',
                          child: Text('Čeština', style: context.textTheme.body),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        App.of(context)?.setLocale(Locale(value));
                      },
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
