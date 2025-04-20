import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/l10n/l10n.dart';

String? Function(String?) usePasswordValidator() {
  final context = useContext();

  final requiredError = context.l10n.requiredValidation;
  final wrongPasswordLengthError = context.l10n.wrongPasswordLength;

  return (String? password) {
    if (password == null || password.isEmpty) {
      return requiredError;
    }

    if (password.length < 8) {
      return wrongPasswordLengthError;
    }

    return null;
  };
}
