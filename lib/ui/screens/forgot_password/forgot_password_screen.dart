import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:sportmatter/data/params/forgotPassword/forgot_password_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/forgot_password/use_forgot_password.dart';
import 'package:sportmatter/hooks/form/use_form_field.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/widgets/language_switcher/language_switcher.dart';


@RoutePage()
class ForgotPasswordScreen extends HookWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final (emailController, emailFocusNode) = useFormField();
    final (isLoading, forgotPassword) = useForgotPasswordMutation();

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
              focusNodes: [emailFocusNode],
              builder: (context, validate) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.forgotPassword,
                      style: context.textTheme.h1,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(context.l10n.email, style: context.textTheme.body),
                    ),
                    const Gap(16),
                    FormTextField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      hintText: context.l10n.email,
                    ),
                    const Gap(32),
                    PrimaryButton(
                      text: context.l10n.sendResetLink,
                      onPressed: () async {
                        if (!validate()) return;

                        final result = await forgotPassword(
                          ForgotPasswordParams(email: emailController.value.text),
                        );

                        if (result is DataSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.l10n.resetLinkSent),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.l10n.resetLinkError),
                            ),
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
