import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/country/country_model.dart';
import 'package:sportmatter/data/models/sport/sport_model.dart';
import 'package:sportmatter/data/params/league/league_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/league/use_league_mutation.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';

@RoutePage()
class LeagueFormScreen extends HookWidget {
  const LeagueFormScreen({
    @PathParam('leagueId') this.leagueId,
    super.key,
  });

  final int? leagueId;

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final associationController = useTextEditingController();

    final selectedCountry = useState<CountryModel?>(null);
    final selectedSport = useState<SportModel?>(null);
    final pickedImageBytes = useState<Uint8List?>(null);

    final countries = useState<List<CountryModel>>([]);
    final sports = useState<List<SportModel>>([]);

    final focusNodes = useMemoized(() => List.generate(2, (_) => FocusNode()), []);
    final (isSaving, createLeague) = useLeagueMutation();

    final repository = useApiRepository();
    final isLoading = useState(true);

    useEffect(() {
      () async {
        final countryResult = await repository.getCountries();
        if (countryResult is DataSuccess) {
          countries.value = countryResult.data!;
        }

        final sportResult = await repository.getSports();
        if (sportResult is DataSuccess) {
          sports.value = sportResult.data!;
        }

        if (leagueId != null) {
          final result = await repository.getLeagueById(leagueId!);
          if (result is DataSuccess) {
            final league = result.data!;
            nameController.text = league.name;
            associationController.text = league.assocation ?? '';

            selectedCountry.value = league.country;
            selectedSport.value = league.sport;
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
                  TextFormFieldLabel(text: context.l10n.leagueName),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: nameController,
                    focusNode: focusNodes[0],
                    hintText: context.l10n.leagueNameHint,
                    validator: (v) => v == null || v.isEmpty ? context.l10n.requiredValidation : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: context.l10n.association),
                  const SizedBox(height: 8),
                  FormTextField(
                    controller: associationController,
                    focusNode: focusNodes[1],
                    hintText: context.l10n.associationHint,
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: context.l10n.sport),
                  const SizedBox(height: 8),
                  DropdownSearch<SportModel>(
                    selectedItem: selectedSport.value,
                    items: sports.value,
                    itemAsString: (sport) => sport.name,
                    dropdownBuilder: (context, selectedItem) => Text(
                      selectedItem?.name ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: context.l10n.selectSport,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (value) => selectedSport.value = value,
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
                    itemAsString: (country) => country.name ?? '',
                    dropdownBuilder: (context, selectedItem) => Text(
                      selectedItem?.name ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
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
                  TextFormFieldLabel(text: context.l10n.leagueLogo),
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
                        child: Text(context.l10n.selectImage),
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

                      final params = LeagueParams(
                        name: nameController.text,
                        assocation: associationController.text.isEmpty ? null : associationController.text,
                        country: selectedCountry.value?.id,
                        sport: selectedSport.value?.id,
                        imageBase64: base64Image,
                      );

                      final result = leagueId == null
                          ? await createLeague(params)
                          : await repository.updateLeague(leagueId!, params);

                      if (result is DataSuccess) {
                        final msg = leagueId == null
                            ? context.l10n.leagueCreated
                            : context.l10n.leagueUpdated;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));
                        await context.router.replace(const LeagueRoute());
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
