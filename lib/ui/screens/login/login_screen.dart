import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/login/login_model.dart';
import 'package:sportmatter/data/params/login/login_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/gen/assets.gen.dart';
import 'package:sportmatter/hooks/form/use_form_field.dart';
import 'package:sportmatter/hooks/login/use_login_mutation.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';
import 'package:sportmatter/widgets/language_switcher/language_switcher.dart';
import 'package:sportmatter/widgets/loader_overlay/loader_overlay.dart';


@RoutePage()
class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final (isPending, login) = useLoginMutation();

    return Scaffold(
      body: Container(
        width: context.mq.size.width,
        height: context.mq.size.height,
        decoration: BoxDecoration(
          gradient: context.theme.primaryGradient,
        ),
        child: Stack(
          children: [
            Positioned(
              top: context.mq.padding.top + 16,
              left: 16,
              child: const LanguageSwitcher(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 39)
                  .copyWith(top: context.mq.padding.top),
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 600,
                        ),
                        child: LoginForm(
                          login: login,
                          isPending: isPending,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (isPending) LoaderOverlay(),
          ],
        ),
      ),
    );
  }
}



class LoginForm extends HookWidget {
  final Future<DataState<LoginModel>> Function(LoginParams) login;
  final bool isPending;

  const LoginForm({super.key, required this.login, required this.isPending});

  @override
  Widget build(BuildContext context) {
    final (emailController, emailFocusNode) = useFormField();
    final (passwordContreoller, passwordFocusNode) = useFormField();

    return FormBuilder(
      focusNodes: [emailFocusNode, passwordFocusNode],
      builder: (context, validate) {
        return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Assets.icons.logoSplash.svg(width: 100, height: 100)),
              const Gap(16),
              Center(
                child: Text(
                  context.l10n.title,
                  style: context.textTheme.h1,
                ),
              ),
              const Gap(48),
              TextFormFieldLabel(text: context.l10n.email),
              const Gap(4),
              FormTextField(
                controller: emailController,
                focusNode: emailFocusNode,
              ),
              const Gap(24),
              TextFormFieldLabel(text: context.l10n.password),
              const Gap(4),
              FormTextField(
                controller: passwordContreoller,
                focusNode: passwordFocusNode,
                obscureText: true,
              ),
              const Gap(24),
              PrimaryButton(
                text: context.l10n.forgotPassword,
                onPressed: () {
                  context.router.push(const ForgotPasswordRoute());
                },
                isDisabled: isPending,
                variant: ButtonVariant.text,
              ),
              const Gap(48),
              PrimaryButton(
                text: context.l10n.login,
                onPressed: () async {
                  if (!validate()) {
                    return;
                  }

                  final succes = await login(
                    LoginParams(
                        username: emailController.value.text,
                        password: passwordContreoller.value.text),
                  );

                  if (succes is DataSuccess) {
                    await context.router.replace(const HomeRoute());
                    return;
                  }

                  if (succes is DataFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        context.l10n.loginFailed,
                        style: context.textTheme.body,
                      ),
                    ));
                  }
                },
                isDisabled: isPending,
              ),
            ]);
      },
    );
  }
}
