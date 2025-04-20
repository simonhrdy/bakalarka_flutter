import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportmatter/config/themes/app_theme.dart';
import 'package:sportmatter/config/themes/text_theme.dart';

extension BuildContextExtensions on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);
}

extension ThemeExtension on BuildContext {
  AppTheme get theme => Provider.of<AppTheme>(this, listen: false);

  ThemeData get td => Theme.of(this);

  ColorScheme get color => td.colorScheme;

  SportMatterTextTheme get textTheme => theme.textTheme;
}

extension BoolExtension on bool {
  bool get not => !this;
}
