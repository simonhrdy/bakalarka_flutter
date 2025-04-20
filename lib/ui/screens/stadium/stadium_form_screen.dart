import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/data/params/stadium/stadium_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/hooks/stadium/use_stadium_mutation.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';

@RoutePage()
class StadiumFormScreen extends HookWidget {
  const StadiumFormScreen({
    @PathParam('stadiumId') this.stadiumId,
    super.key,
  });

  final int? stadiumId;

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final capacityController = useTextEditingController();
    final focusNodes = useMemoized(() => [FocusNode(), FocusNode()], []);
    final isLoading = useState(stadiumId != null);
    final repository = useApiRepository();
    final (isSaving, createStadium) = useStadiumMutation();

    useEffect(() {
      if (stadiumId != null) {
        () async {
          final result = await repository.getStadiumById(stadiumId!);
          if (result is DataSuccess) {
            nameController.text = result.data!.name;
            capacityController.text = result.data!.capacity?.toString() ?? '0';
          }
          isLoading.value = false;
        }();
      } else {
        isLoading.value = false;
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
                  TextFormFieldLabel(text: context.l10n.stadiumFormName),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: nameController,
                    focusNode: focusNodes[0],
                    hintText: context.l10n.stadiumFormNameHint,
                    validator: (value) =>
                    (value == null || value.isEmpty) ? context.l10n.requiredValidation : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: context.l10n.stadiumFormCapacity),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: capacityController,
                    focusNode: focusNodes[1],
                    hintText: context.l10n.stadiumFormCapacityHint,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                        return context.l10n.validationInvalidNumber;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: context.l10n.save,
                    isDisabled: isSaving,
                    onPressed: () async {
                      final isValid = validate();
                      if (!isValid) return;

                      final params = StadiumParams(
                        name: nameController.text,
                        capacity: int.tryParse(capacityController.text) ?? 0,
                      );

                      final result = stadiumId == null
                          ? await createStadium(params)
                          : await repository.updateStadium(stadiumId!, params);

                      if (result is DataSuccess) {
                        final msg = stadiumId == null
                            ? context.l10n.stadiumCreated
                            : context.l10n.stadiumUpdated;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));
                        await context.router.replaceNamed('/stadium');
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
