import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/params/country/country_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/country/use_country_mutation.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';

@RoutePage()
class CountryFormScreen extends HookWidget {
  const CountryFormScreen({
    @PathParam('countryId') this.countryId,
    super.key,
  });

  final int? countryId;

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final nameShortController = useTextEditingController();
    final focusNodes = useMemoized(() => [FocusNode(), FocusNode()], []);
    final (isSaving, createCountry) = useCountryMutation();

    final repository = useApiRepository();
    final isLoading = useState(countryId != null);

    useEffect(() {
      if (countryId != null) {
        () async {
          final result = await repository.getCountryById(countryId!);
          if (result is DataSuccess) {
            nameController.text = result.data!.name ?? '';
            nameShortController.text = result.data!.nameShort ?? '';
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
        child: SingleChildScrollView( // ✅ přidán scroll
          child: FormBuilder(
            focusNodes: focusNodes,
            builder: (context, validate) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormFieldLabel(text: context.l10n.countryName),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: nameController,
                    focusNode: focusNodes[0],
                    hintText: context.l10n.countryNameHint,
                    validator: (value) =>
                    (value == null || value.isEmpty)
                        ? context.l10n.requiredValidation
                        : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: context.l10n.teamShortName),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: nameShortController,
                    focusNode: focusNodes[1],
                    hintText: context.l10n.countryShortNameHint,
                    validator: (value) =>
                    (value == null || value.isEmpty)
                        ? context.l10n.requiredValidation
                        : null,
                  ),
                  const SizedBox(height: 32), // místo Spacer kvůli scrollování
                  PrimaryButton(
                    text: context.l10n.save,
                    isDisabled: false,
                    onPressed: () async {
                      final isValid = validate();
                      if (!isValid) return;

                      final params = CountryParams(
                        name: nameController.text,
                        nameShort: nameShortController.text,
                      );

                      final result = countryId == null
                          ? await createCountry(params)
                          : await repository.updateCountry(countryId!, params);

                      if (result is DataSuccess) {
                        final msg = countryId == null
                            ? context.l10n.countryCreated
                            : context.l10n.countryUpdated;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));
                        await context.router.replace(const CountryRoute());
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
