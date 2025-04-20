import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FormBuilder extends HookWidget {
  final List<FocusNode> focusNodes;
  final Widget Function(BuildContext, bool Function()) builder;

  FormBuilder({super.key, required this.builder, required this.focusNodes});

  @override
  Widget build(BuildContext context) {
    final formKeyRef = useRef(GlobalKey<FormState>());

    void unFocus() {
      focusNodes.forEach((element) {
        element.unfocus();
      });
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: unFocus,
      child: Form(
          key: formKeyRef.value,
          child: builder(
            context,
            () {
              unFocus();
              return formKeyRef.value.currentState!.validate();
            },
          )),
    );
  }
}
