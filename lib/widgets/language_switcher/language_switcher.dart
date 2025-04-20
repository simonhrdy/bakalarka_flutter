import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import 'package:sportmatter/app.dart';
import 'package:sportmatter/config/extensions/extensions.dart';

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({super.key});

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  final GlobalKey btnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final currentLang = Localizations.localeOf(context).languageCode;

    PopupMenu menu = PopupMenu(
      context: context,
      config: MenuConfig(
        backgroundColor: context.theme.secondary,
        lineColor: Colors.white,
        highlightColor: Colors.white,
      ),
      items: [
        PopUpMenuItem(
          title: 'EN',
          textStyle: context.textTheme.body.copyWith(
            color: currentLang == 'en'
                ? context.theme.white
                : context.theme.black,
          ),
        ),
        PopUpMenuItem(
          title: 'CZ',
          textStyle: context.textTheme.body.copyWith(
            color: currentLang == 'cs'
                ? context.theme.white
                : context.theme.black,
          ),
        ),
      ],
      onClickMenu: (item) {
        if (item.menuTitle == 'EN') {
          App.of(context)?.setLocale(const Locale('en'));
        } else if (item.menuTitle == 'CZ') {
          App.of(context)?.setLocale(const Locale('cs'));
        }
        setState(() {});
      },
    );

    return GestureDetector(
      key: btnKey,
      onTap: () {
        menu.show(widgetKey: btnKey);
      },
      child: const FaIcon(
        FontAwesomeIcons.earthEurope,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
