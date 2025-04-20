import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/params/referee/referee_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/referee/use_referee_mutation.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';

@RoutePage()
class RefereeFormScreen extends HookWidget {
  const RefereeFormScreen({
    @PathParam('refereeId') this.refereeId,
    super.key,
  });

  final int? refereeId;

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final surnameController = useTextEditingController();
    final focusNodes = useMemoized(() => [FocusNode(), FocusNode()], []);
    final (isSaving, createReferee) = useRefereeMutation();

    final repository = useApiRepository();
    final isLoading = useState(refereeId != null);

    useEffect(() {
      if (refereeId != null) {
        () async {
          final result = await repository.getRefereeById(refereeId!);
          if (result is DataSuccess) {
            nameController.text = result.data!.name;
            surnameController.text = result.data!.surname;
          }
          isLoading.value = false;
        }();
      }
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
                    hintText: 'Např. Petr',
                    validator: (value) =>
                    (value == null || value.isEmpty)
                        ? context.l10n.requiredValidation
                        : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: context.l10n.surnameColumn),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: surnameController,
                    focusNode: focusNodes[1],
                    hintText: 'Např. Novák',
                    validator: (value) =>
                    (value == null || value.isEmpty)
                        ? context.l10n.requiredValidation
                        : null,
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: context.l10n.save,
                    isDisabled: isSaving,
                    onPressed: () async {
                      final isValid = validate();
                      if (!isValid) return;

                      final params = RefereeParams(
                        name: nameController.text,
                        surname: surnameController.text,
                      );

                      final result = refereeId == null
                          ? await createReferee(params)
                          : await repository.updateReferee(refereeId!, params);

                      if (result is DataSuccess) {
                        final msg = refereeId == null
                            ? context.l10n.refereeCreated
                            : context.l10n.refereeUpdated;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));

                        await context.router.replace(const RefereeRoute());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.error)),
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
