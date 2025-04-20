import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/stadium/stadium_model.dart';
import 'package:sportmatter/data/params/team/team_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/hooks/team/use_team_mutation.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';

@RoutePage()
class TeamFormScreen extends HookWidget {
  const TeamFormScreen({
    @PathParam('teamId') this.teamId,
    super.key,
  });

  final int? teamId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final nameController = useTextEditingController();
    final surnameController = useTextEditingController();
    final nameShortController = useTextEditingController();
    final coachController = useTextEditingController();
    final pickedImageBytes = useState<Uint8List?>(null);

    final focusNodes = useMemoized(() => [
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
    ], []);

    final selectedStadium = useState<StadiumModel?>(null);
    final stadiums = useState<List<StadiumModel>>([]);
    final isLoading = useState(teamId != null);
    final repository = useApiRepository();
    final (isSaving, createTeam) = useTeamMutation();

    useEffect(() {
      () async {
        final stadiumResult = await repository.getAvailableStadiums();
        if (stadiumResult is DataSuccess) {
          stadiums.value = stadiumResult.data!;
        }

        if (teamId != null) {
          final teamResult = await repository.getTeamById(teamId!);
          if (teamResult is DataSuccess) {
            final team = teamResult.data!;
            nameController.text = team.name;
            surnameController.text = team.surname ?? '';
            nameShortController.text = team.nameShort ?? '';
            coachController.text = team.coach ?? '';

            if (team.stadium != null) {
              selectedStadium.value = team.stadium!;
              if (!stadiums.value.any((s) => s.id == team.stadium!.id)) {
                stadiums.value = [...stadiums.value, team.stadium!];
              }
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
                  TextFormFieldLabel(text: l10n.teamName),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: nameController,
                    focusNode: focusNodes[0],
                    hintText: l10n.teamNameHint,
                    validator: (value) =>
                    (value == null || value.isEmpty) ? l10n.requiredValidation : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: l10n.teamSurname),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: surnameController,
                    focusNode: focusNodes[1],
                    hintText: l10n.teamSurnameHint,
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: l10n.teamShortName),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: nameShortController,
                    focusNode: focusNodes[2],
                    hintText: l10n.teamShortNameHint,
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: l10n.teamCoach),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: coachController,
                    focusNode: focusNodes[3],
                    hintText: l10n.teamCoachHint,
                  ),
                  const SizedBox(height: 24),
                  if (teamId != null && selectedStadium.value != null) ...[
                    Text('${l10n.currentStadium}: ${selectedStadium.value!.name}',
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text(
                      l10n.stadiumInfo,
                      style: const TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormFieldLabel(text: l10n.teamNewStadium),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<StadiumModel>(
                    isExpanded: true,
                    dropdownColor: Colors.black,
                    value: null,
                    hint: Text(l10n.teamNewStadiumHint),
                    items: stadiums.value.map((stadium) {
                      return DropdownMenuItem(
                        value: stadium,
                        child: Text(stadium.name, style: context.textTheme.body),
                      );
                    }).toList(),
                    onChanged: (value) => selectedStadium.value = value,
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: l10n.teamLogo),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            allowMultiple: false,
                            withData: true,
                          );

                          if (result != null && result.files.isNotEmpty) {
                            pickedImageBytes.value = result.files.first.bytes;
                          }
                        },
                        child: Text(l10n.selectImage),
                      ),
                      const SizedBox(width: 16),
                      if (pickedImageBytes.value != null)
                        Image.memory(
                          pickedImageBytes.value!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: l10n.save,
                    isDisabled: isSaving,
                    onPressed: () async {
                      final isValid = validate();
                      if (!isValid) return;

                      String? base64Image;
                      if (pickedImageBytes.value != null) {
                        base64Image = base64Encode(pickedImageBytes.value!);
                      }

                      final params = TeamParams(
                        name: nameController.text,
                        surname: surnameController.text.isEmpty ? null : surnameController.text,
                        nameShort:
                        nameShortController.text.isEmpty ? null : nameShortController.text,
                        coach: coachController.text.isEmpty ? null : coachController.text,
                        stadiumId: selectedStadium.value?.id,
                        imageBase64: base64Image,
                      );

                      final result = teamId == null
                          ? await createTeam(params)
                          : await repository.updateTeam(teamId!, params);

                      if (result is DataSuccess) {
                        final msg = teamId == null
                            ? l10n.teamCreateSuccess
                            : l10n.teamUpdateSuccess;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));
                        await context.router.replace(const TeamRoute());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.error)),
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
