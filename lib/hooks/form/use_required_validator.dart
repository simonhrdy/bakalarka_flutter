import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/l10n/l10n.dart';

String? Function(String?) useRequiredValidator() {
  final context = useContext();

  final requiredError = context.l10n.requiredValidation;

  return (value) {
    if (value == null || value.isEmpty) {
      return requiredError;
    }
    return null;
  };
}
