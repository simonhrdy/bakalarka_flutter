import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/params/user/user_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';
import 'package:sportmatter/l10n/l10n.dart';

@RoutePage()
class UserFormScreen extends HookWidget {
  final int? userId;

  const UserFormScreen({super.key, @PathParam('userId') this.userId});

  @override
  Widget build(BuildContext context) {
    final isEditing = userId != null;
    final repository = useApiRepository();

    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final selectedRole = useState<String?>('ROLE_USER');

    final focusNodes = useMemoized(() => List.generate(4, (_) => FocusNode()), []);
    final isLoading = useState(true);
    final isSaving = useState(false);

    final roleOptions = {
      'ROLE_USER': context.l10n.roleUser,
      'ROLE_REDACTOR': context.l10n.roleRedactor,
      'ROLE_MANAGER': context.l10n.roleManager,
      'ROLE_SUPERADMIN': context.l10n.roleSuperadmin,
    };

    useEffect(() {
      () async {
        if (userId != null) {
          final result = await repository.getUserById(userId!);
          if (result is DataSuccess && result.data != null) {
            final user = result.data!;
            nameController.text = user.name;
            emailController.text = user.email;
            if (user.roles.isNotEmpty) {
              selectedRole.value = user.roles.first;
            }
          }
        }
        isLoading.value = false;
      }();
      return null;
    }, []);

    if (isLoading.value) {
      return const MainScaffold(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            focusNodes: focusNodes,
            builder: (context, validate) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormFieldLabel(text: context.l10n.name),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: nameController,
                    focusNode: focusNodes[0],
                    hintText: context.l10n.nameHint,
                    validator: (v) => v == null || v.isEmpty ? context.l10n.requiredValidation : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: context.l10n.email),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: emailController,
                    focusNode: focusNodes[1],
                    hintText: context.l10n.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v == null || !v.contains('@') ? context.l10n.invalidEmail : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: context.l10n.password),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: passwordController,
                    focusNode: focusNodes[2],
                    hintText: context.l10n.passwordHint,
                    obscureText: true,
                    validator: (v) {
                      if (!isEditing && (v == null || v.length < 6)) {
                        return context.l10n.passwordMinLength;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: context.l10n.role),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedRole.value,
                    hint: Text(context.l10n.selectRole, style: const TextStyle(color: Colors.white)),
                    items: roleOptions.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) => selectedRole.value = value,
                    validator: (value) =>
                    value == null || value.isEmpty ? context.l10n.selectRoleError : null,
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: isEditing ? context.l10n.edit : context.l10n.create,
                    isDisabled: isSaving.value,
                    onPressed: () async {
                      final isValid = validate();
                      if (!isValid) return;

                      isSaving.value = true;

                      final params = UserParams(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        roles: [selectedRole.value ?? 'ROLE_USER'],
                        password: passwordController.text.trim().isEmpty
                            ? null
                            : passwordController.text.trim(),
                      );

                      final result = isEditing
                          ? await repository.updateUser(userId!, params)
                          : await repository.createUser(params);

                      isSaving.value = false;

                      if (result is DataSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isEditing ? context.l10n.userEdited : context.l10n.userCreated)),
                        );
                        await context.router.replace(const UserRoute());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.userSaveFailed)),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
