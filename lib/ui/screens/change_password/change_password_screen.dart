import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/params/changePassword/change_password_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/change_password/use_change_password_mutation.dart';
import 'package:sportmatter/hooks/form/use_form_field.dart';
import 'package:sportmatter/hooks/user/use_current_user.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';
import 'package:sportmatter/widgets/language_switcher/language_switcher.dart';

@RoutePage()
class ResetPasswordScreen extends HookWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final (passwordController, passwordFocusNode) = useFormField();
    final (confirmPasswordController, confirmPasswordFocusNode) = useFormField();

    final (isLoading, changePassword) = useChangePasswordMutation();
    final currentUser = useCurrentUser();
    final userId = currentUser?.id;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: LanguageSwitcher(),
          )
        ],
      ),
      body: Container(
        width: context.mq.size.width,
        height: context.mq.size.height,
        decoration: BoxDecoration(
          gradient: context.theme.primaryGradient,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.theme.primary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            width: 600,
            child: FormBuilder(
              focusNodes: [passwordFocusNode, confirmPasswordFocusNode],
              builder: (context, validate) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.resetPassword,
                      style: context.textTheme.h1,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(32),

                    // Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(context.l10n.password, style: context.textTheme.body),
                    ),
                    const Gap(16),
                    FormTextField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      hintText: context.l10n.password,
                      obscureText: true,
                    ),
                    const Gap(24),

                    // Confirm Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(context.l10n.confirmPassword, style: context.textTheme.body),
                    ),
                    const Gap(16),
                    FormTextField(
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocusNode,
                      hintText: context.l10n.confirmPassword,
                      obscureText: true,
                    ),
                    const Gap(32),

                    PrimaryButton(
                      text: context.l10n.changePassword,
                      onPressed: () async {
                        if (!validate()) return;

                        if (passwordController.value.text != confirmPasswordController.value.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.l10n.passwordsDoNotMatch),
                            ),
                          );
                          return;
                        }

                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.userNotFound)),
                          );
                          return;
                        }

                        final result = await changePassword(
                          userId,
                          ChangePasswordParams(password: passwordController.value.text),
                        );

                        if (result is DataSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.passwordChangedSuccess)),
                          );
                          await context.router.replace(const HomeRoute());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.passwordChangeFailed)),
                          );
                        }
                      },
                      isDisabled: isLoading,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
