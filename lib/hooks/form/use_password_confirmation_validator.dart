import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/l10n/l10n.dart';

String? Function(String?) usePasswordConfirmationValidator(
  TextEditingController passwordController,
) {
  final context = useContext();

  final requiredError = context.l10n.requiredValidation;
  final passwordsDoNotMatchError = context.l10n.passwordsDoNotMatch;

  return (String? passwordConfirmation) {
    if (passwordConfirmation == null || passwordConfirmation.isEmpty) {
      return requiredError;
    }
    if (passwordConfirmation == passwordController.text) {
      return null;
    }
    return passwordsDoNotMatchError;
  };
}
