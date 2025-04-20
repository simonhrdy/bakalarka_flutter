import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportmatter/config/constants/constants.dart';

VoidCallback useLogout(VoidCallback onLoggedOut) {
  return () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kTokenKey);
    await prefs.remove(kCurrentUserKey);
    onLoggedOut();
  };
}
