import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/hooks/form/use_form_field.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';
import 'package:sportmatter/l10n/l10n.dart';

@RoutePage()
class ResetPasswordScreen extends HookWidget {
  const ResetPasswordScreen({super.key, @PathParam('token') required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    final (passwordController, passwordFocus) = useFormField();
    final (repeatController, repeatFocus) = useFormField();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.resetPassword),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: FormBuilder(
          focusNodes: [passwordFocus, repeatFocus],
          builder: (context, validate) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.enterNewPassword),
                const Gap(16),
                FormTextField(
                  controller: passwordController,
                  focusNode: passwordFocus,
                  hintText: context.l10n.password,
                  obscureText: true,
                ),
                const Gap(16),
                FormTextField(
                  controller: repeatController,
                  focusNode: repeatFocus,
                  hintText: context.l10n.repeatPassword,
                  obscureText: true,
                ),
                const Gap(24),
                PrimaryButton(
                  text: context.l10n.resetPassword,
                  onPressed: () {
                    if (!validate()) return;

                    if (passwordController.value.text != repeatController.value.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.passwordsDoNotMatch)),
                      );
                      return;
                    }

                    // TODO: api na změnu hesla s tokenem

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password changed')),
                    );

                    context.router.replace(const LoginRoute());
                  },
                  isDisabled: false,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
