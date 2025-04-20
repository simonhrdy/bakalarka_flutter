import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/extensions/extensions.dart';

class FormTextField extends HookWidget {
  final String? hintText;
  final bool? enabled;
  final int? maxLines;
  final String? errorText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Widget? suffixIcon;
  final bool? readOnly;
  final VoidCallback? onTap;

  FormTextField({
    super.key,
    this.hintText,
    this.enabled,
    this.maxLines = 1,
    this.validator,
    this.focusNode,
    this.errorText,
    this.keyboardType,
    this.obscureText,
    this.suffixIcon,
    this.controller,
    this.readOnly,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isObscured = useState(obscureText ?? false);

    return TextFormField(
      enabled: enabled,
      maxLines: maxLines,
      focusNode: focusNode,
      controller: controller,
      validator: validator,
      readOnly: readOnly ?? false,
      onTap: onTap,
      keyboardType: keyboardType,
      style: context.textTheme.body,
      obscureText: isObscured.value,
      decoration: InputDecoration(
        suffixIcon: obscureText != true
            ? suffixIcon
            : Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Icon(
              isObscured.value ? Icons.visibility_off : Icons.visibility,
              color: context.theme.white,
            ),
            onPressed: () => isObscured.value = !isObscured.value,
          ),
        ),
        errorText: errorText,
        filled: true,
        fillColor: context.theme.secondary,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.grey, width: 4),
            borderRadius: BorderRadius.circular(16)),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.border, width: 3),
            borderRadius: BorderRadius.circular(16)),
        contentPadding: MediaQuery.of(context).size.width > 600
            ? const EdgeInsets.symmetric(horizontal: 24, vertical: 20)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.border, width: 3),
            borderRadius: BorderRadius.circular(16)),
        hintText: hintText,
      ),
    );
  }
}


class TextFormFieldLabel extends StatelessWidget {
  String text;

  TextFormFieldLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.body,
    );
  }
}
