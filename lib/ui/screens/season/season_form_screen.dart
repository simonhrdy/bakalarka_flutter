import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sportmatter/data/models/league/league_model.dart';
import 'package:sportmatter/data/params/season/season_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/hooks/season/use_season_mutation.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';

@RoutePage()
class SeasonFormScreen extends HookWidget {
  const SeasonFormScreen({
    @PathParam('seasonId') this.seasonId,
    super.key,
  });

  final int? seasonId;

  @override
  Widget build(BuildContext context) {
    final startController = useTextEditingController();
    final endController = useTextEditingController();
    final isActive = useState(false);

    final leagues = useState<List<LeagueModel>>([]);
    final selectedLeague = useState<LeagueModel?>(null);

    final isLoading = useState(true);
    final repository = useApiRepository();
    final (isSaving, createSeason) = useSeasonMutation();

    final focusNodes = useMemoized(() => List.generate(3, (_) => FocusNode()), []);

    useEffect(() {
      () async {
        final leagueResult = await repository.getLeagues();
        if (leagueResult is DataSuccess) {
          leagues.value = leagueResult.data!;
        }

        if (seasonId != null) {
          final seasonResult = await repository.getSeasonById(seasonId!);
          if (seasonResult is DataSuccess) {
            final season = seasonResult.data!;
            startController.text = DateFormat('yyyy-MM-dd').format(season.yearStart!);
            endController.text = DateFormat('yyyy-MM-dd').format(season.yearEnd!);
            isActive.value = season.isActive;

            try {
              selectedLeague.value = leagues.value.firstWhere((c) => c.id == season.leagueId);
            } catch (_) {
              selectedLeague.value = null;
            }
          }
        }

        isLoading.value = false;
      }();
      return null;
    }, []);

    Future<void> pickDate(TextEditingController controller) async {
      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }

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
                  TextFormFieldLabel(text: context.l10n.league),
                  const SizedBox(height: 8),
                  DropdownSearch<LeagueModel>(
                    selectedItem: selectedLeague.value,
                    items: leagues.value,
                    itemAsString: (LeagueModel league) => league.name,
                    dropdownBuilder: (context, selectedItem) => Text(
                      selectedItem?.name ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: context.l10n.selectLeague,
                        hintStyle: const TextStyle(color: Colors.white70),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (value) => selectedLeague.value = value,
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
                  TextFormFieldLabel(text: context.l10n.startSeason),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: startController,
                    style: const TextStyle(color: Colors.white),
                    readOnly: true,
                    onTap: () => pickDate(startController),
                    decoration: InputDecoration(
                      hintText: context.l10n.selectStartDate,
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormFieldLabel(text: context.l10n.endSeason),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: endController,
                    style: const TextStyle(color: Colors.white),
                    readOnly: true,
                    onTap: () => pickDate(endController),
                    decoration: InputDecoration(
                      hintText: context.l10n.selectEndDate,
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Checkbox(
                        value: isActive.value,
                        onChanged: (value) => isActive.value = value ?? false,
                      ),
                      Text(context.l10n.seasonActive, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: context.l10n.save,
                    isDisabled: isSaving,
                    onPressed: () async {
                      if (selectedLeague.value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.selectLeague)),
                        );
                        return;
                      }

                      final start = DateTime.tryParse(startController.text);
                      final end = DateTime.tryParse(endController.text);

                      if (start == null || end == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.errorInvalidDates)),
                        );
                        return;
                      }

                      final params = SeasonParams(
                        leagueId: selectedLeague.value!.id,
                        yearStart: start,
                        yearEnd: end,
                        isActive: isActive.value,
                      );

                      final result = seasonId == null
                          ? await createSeason(params)
                          : await repository.updateSeason(seasonId!, params);

                      if (result is DataSuccess) {
                        final msg = seasonId == null
                            ? context.l10n.seasonCreated
                            : context.l10n.seasonUpdated;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));
                        await context.router.replaceNamed('/season');
                      } else {
                        if (result is DataFailed && result.error is DioException) {
                          final dioError = result.error!;
                          final message = dioError.response?.data?['message'] ?? context.l10n.error;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message as String)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.error)),
                          );
                        }
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
