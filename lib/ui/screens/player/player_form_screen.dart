import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/country/country_model.dart';
import 'package:sportmatter/data/models/team/team_model.dart';
import 'package:sportmatter/data/params/player/player_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/player/use_player_mutation.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';

@RoutePage()
class PlayerFormScreen extends HookWidget {
  const PlayerFormScreen({
    @PathParam('playerId') this.playerId,
    super.key,
  });

  final int? playerId;

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final surnameController = useTextEditingController();
    final numberController = useTextEditingController();
    final positionController = useTextEditingController();

    final selectedTeam = useState<TeamModel?>(null);
    final selectedCountry = useState<CountryModel?>(null);

    final pickedImageBytes = useState<Uint8List?>(null);

    final teams = useState<List<TeamModel>>([]);
    final countries = useState<List<CountryModel>>([]);

    final focusNodes = useMemoized(() => List.generate(4, (_) => FocusNode()), []);
    final (isSaving, createPlayer) = usePlayerMutation();

    final repository = useApiRepository();
    final isLoading = useState(true);

    useEffect(() {
      () async {
        final teamsResult = await repository.getTeams();
        if (teamsResult is DataSuccess) {
          teams.value = teamsResult.data!;
        }

        final countriesResult = await repository.getCountries();
        if (countriesResult is DataSuccess) {
          countries.value = countriesResult.data!;
        }

        if (playerId != null) {
          final result = await repository.getPlayerById(playerId!);
          if (result is DataSuccess) {
            final player = result.data!;
            nameController.text = player.name;
            surnameController.text = player.surname ?? '';
            numberController.text = player.number?.toString() ?? '';
            positionController.text = player.position ?? '';

            if (player.team != null) {
              try {
                selectedTeam.value = teams.value.firstWhere((t) => t.id == player.team!.id);
              } catch (_) {
                selectedTeam.value = null;
              }
            }

            if (player.country != null) {
              try {
                selectedCountry.value = countries.value.firstWhere((c) => c.id == player.country!.id);
              } catch (_) {
                selectedCountry.value = null;
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
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
                            hintText: 'Např. Jan',
                            validator: (v) => v == null || v.isEmpty ? context.l10n.requiredValidation : null,
                          ),
                          const SizedBox(height: 24),
                          TextFormFieldLabel(text: context.l10n.surnameColumn),
                          const SizedBox(height: 8),
                          FormTextField(
                            controller: surnameController,
                            focusNode: focusNodes[1],
                            hintText: 'Např. Novák',
                          ),
                          const SizedBox(height: 24),
                          TextFormFieldLabel(text: context.l10n.position),
                          const SizedBox(height: 8),
                          DropdownSearch<String>(
                            selectedItem: positionController.text.isNotEmpty ? positionController.text : null,
                            items: [context.l10n.positionForward,
                              context.l10n.positionMidfielder,
                              context.l10n.positionDefender,
                              context.l10n.positionGoalkeeper,
                              context.l10n.positionUnknown
                                    ],
                            dropdownBuilder: (context, selectedItem) => Text(
                              selectedItem ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: context.l10n.selectPosition,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            onChanged: (value) {
                              positionController.text = value ?? '';
                            },
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              itemBuilder: (context, item, isSelected) => Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(item, style: const TextStyle(color: Colors.white)),
                              ),
                              menuProps: const MenuProps(
                                backgroundColor: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormFieldLabel(text: context.l10n.jerseyNumber),
                          const SizedBox(height: 8),
                          FormTextField(
                            controller: numberController,
                            focusNode: focusNodes[3],
                            hintText: 'Např. 10',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 24),
                          TextFormFieldLabel(text: context.l10n.selectTeam),
                          const SizedBox(height: 8),
                          DropdownSearch<TeamModel>(
                            selectedItem: selectedTeam.value,
                            items: teams.value,
                            itemAsString: (TeamModel team) => team.name,
                            dropdownBuilder: (context, selectedItem) => Text(
                              selectedItem?.name ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: context.l10n.selectTeam,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            onChanged: (value) => selectedTeam.value = value,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              itemBuilder: (context, item, isSelected) => Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(item.name, style: const TextStyle(color: Colors.white)),
                              ),
                              menuProps: const MenuProps(
                                backgroundColor: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormFieldLabel(text: context.l10n.country),
                          const SizedBox(height: 8),
                          DropdownSearch<CountryModel>(
                            selectedItem: selectedCountry.value,
                            items: countries.value,
                            itemAsString: (CountryModel country) => country.name ?? '',
                            dropdownBuilder: (context, selectedItem) => Text(
                              selectedItem?.name ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                            dropdownDecoratorProps:  DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: context.l10n.selectCountry,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            onChanged: (value) => selectedCountry.value = value,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              itemBuilder: (context, item, isSelected) => Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(item.name ?? '', style: const TextStyle(color: Colors.white)),
                              ),
                              menuProps: const MenuProps(
                                backgroundColor: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormFieldLabel(text: context.l10n.playerPhoto),
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
                                    final file = result.files.first;

                                    if (file.bytes != null) {
                                      pickedImageBytes.value = file.bytes;
                                    }
                                  }
                                },
                                child:  Text(context.l10n.selectImage),
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
                            text: context.l10n.save,
                            isDisabled: isSaving,
                            onPressed: () async {
                              final isValid = validate();
                              if (!isValid) return;

                              String? base64Image;
                              if (pickedImageBytes.value != null) {
                                base64Image = base64Encode(pickedImageBytes.value!);
                              }

                              final params = PlayerParams(
                                name: nameController.text,
                                surname: surnameController.text.isEmpty ? null : surnameController.text,
                                position: positionController.text.isEmpty ? null : positionController.text,
                                number: int.tryParse(numberController.text),
                                team: selectedTeam.value?.id,
                                country: selectedCountry.value?.id,
                                imageBase64: base64Image,
                              );


                              final result = playerId == null
                                  ? await createPlayer(params)
                                  : await repository.updatePlayer(playerId!, params);

                              if (result is DataSuccess) {
                                final msg = playerId == null ? context.l10n.playerCreated : context.l10n.playerUpdated;
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                                await context.router.replace(const PlayerRoute());
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
          },
        ),
      ),
    );
  }
}
