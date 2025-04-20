import 'package:flutter/material.dart';
import 'package:sportmatter/config/extensions/extensions.dart';

enum ButtonVariant { primary, text }

class VariantData {
  final Color backgroundColor;
  final BorderSide borderSide;
  final TextStyle textStyle;
  final EdgeInsets padding;

  VariantData(
      {required this.padding,
      required this.backgroundColor,
      required this.borderSide,
      required this.textStyle});
}

class PrimaryButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final bool isDisabled;
  final ButtonVariant variant;

  PrimaryButton(
      {this.text,
      required this.onPressed,
      required this.isDisabled,
      this.variant = ButtonVariant.primary});

  @override
  Widget build(BuildContext context) {
    final variantData = _getVariant(context, variant);

    return TextButton(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          side: variantData.borderSide,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: variantData.padding,
        overlayColor: Colors.transparent,
      ).copyWith(backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.pressed) &&
              variant != ButtonVariant.text) {
            return context.theme.grey;
          }
          return variantData.backgroundColor;
        },
      )),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(text ?? '',
              textAlign: TextAlign.center, style: variantData.textStyle),
        ],
      ),
    );
  }

  VariantData _getVariant(BuildContext context, ButtonVariant variant) {
    return switch (variant) {
      ButtonVariant.primary => VariantData(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800 ? 48 : 16,
            vertical: MediaQuery.of(context).size.width > 800 ? 24 : 16,
          ),
          backgroundColor: context.theme.secondary,
          borderSide: BorderSide(color: context.theme.white, width: 3),
          textStyle: context.textTheme.body),
      ButtonVariant.text => VariantData(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          borderSide: const BorderSide(color: Colors.transparent, width: 3),
          textStyle: context.textTheme.body.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: context.theme.white),),
    };
  }
}
