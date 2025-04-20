import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/team/team_model.dart';
import 'package:sportmatter/data/models/user/user_model.dart';
import 'package:sportmatter/data/params/match/match_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/hooks/match/use_match_mutation.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/text_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sportmatter/layouts/main_layout.dart';

@RoutePage()
class MatchFormScreen extends HookWidget {
  const MatchFormScreen({
    @PathParam('id') this.id,
    super.key,
  });

  final int? id;

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final (isSaving, createMatch) = useMatchMutation();

    final focusNodes = useMemoized(() => List.generate(10, (_) => FocusNode()), []);
    final dateTimeController = useTextEditingController();
    final roundController = useTextEditingController();

    final players = useState<List<TeamModel>>([]);
    final users = useState<List<UserModel>>([]);

    final player1 = useState<TeamModel?>(null);
    final player2 = useState<TeamModel?>(null);
    final supervisor = useState<UserModel?>(null);

    final bettingTipsController = useTextEditingController();
    final matchAnalysisController = useTextEditingController();

    useEffect(() {
      () async {
        final resPlayers = await repository.getTeams();
        final resUsers = await repository.getUsers();

        if (resPlayers is DataSuccess) players.value = resPlayers.data!;
        if (resUsers is DataSuccess) users.value = resUsers.data!;
      }();
      return null;
    }, []);

    Future<void> pickDateTime() async {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date != null) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
          dateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(dt);
        }
      }
    }

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          focusNodes: focusNodes,
          builder: (context, validate) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FormTextField(
                          controller: dateTimeController,
                          hintText: context.l10n.dateTimeLabel,
                          readOnly: true,
                          onTap: pickDateTime,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FormTextField(
                          controller: roundController,
                          hintText: context.l10n.roundLabel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownSearch<UserModel>(
                          items: users.value,
                          selectedItem: supervisor.value,
                          itemAsString: (u) => u.email,
                          onChanged: (val) => supervisor.value = val,
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            menuProps: const MenuProps(backgroundColor: Colors.black),
                            itemBuilder: (context, item, isSelected) => ListTile(
                              title: Text(item.email, style: const TextStyle(color: Colors.white)),
                              tileColor: isSelected ? Colors.grey[800] : Colors.black,
                            ),
                          ),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: context.l10n.supervisor,
                              labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.black,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          dropdownBuilder: (context, item) => Text(
                            item?.email ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          dropdownButtonProps: const DropdownButtonProps(icon: Icon(Icons.arrow_drop_down, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(context.l10n.team1, style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 10),
                            DropdownSearch<TeamModel>(
                              items: players.value,
                              selectedItem: player1.value,
                              itemAsString: (p) => p.name,
                              onChanged: (val) {
                                if (val?.id == player2.value?.id) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(context.l10n.samePlayerError)),
                                  );
                                  return;
                                }
                                player1.value = val;
                              },
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                menuProps: const MenuProps(backgroundColor: Colors.black),
                                itemBuilder: (context, item, isSelected) => ListTile(
                                  title: Text(item.name, style: const TextStyle(color: Colors.white)),
                                  tileColor: isSelected ? Colors.grey[800] : Colors.black,
                                ),
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: context.l10n.selectTeamOrPlayer,
                                  labelStyle: const TextStyle(color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.black87,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              dropdownBuilder: (context, item) => Text(
                                item?.name ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                              dropdownButtonProps: const DropdownButtonProps(icon: Icon(Icons.arrow_drop_down, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            Text(context.l10n.team2, style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 10),
                            DropdownSearch<TeamModel>(
                              items: players.value,
                              selectedItem: player2.value,
                              itemAsString: (p) => p.name,
                              onChanged: (val) {
                                if (val?.id == player1.value?.id) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(context.l10n.samePlayerError)),
                                  );
                                  return;
                                }
                                player2.value = val;
                              },
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                menuProps: const MenuProps(backgroundColor: Colors.black),
                                itemBuilder: (context, item, isSelected) => ListTile(
                                  title: Text(item.name, style: const TextStyle(color: Colors.white)),
                                  tileColor: isSelected ? Colors.grey[800] : Colors.black,
                                ),
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: context.l10n.selectTeamOrPlayer,
                                  labelStyle: const TextStyle(color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.black87,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              dropdownBuilder: (context, item) => Text(
                                item?.name ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                              dropdownButtonProps: const DropdownButtonProps(icon: Icon(Icons.arrow_drop_down, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(context.l10n.bettingTips, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  FormTextField(
                    controller: bettingTipsController,
                    hintText: context.l10n.bettingTipsHint,
                    maxLines: 6,
                  ),
                  const SizedBox(height: 24),
                  Text(context.l10n.matchAnalysis, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  FormTextField(
                    controller: matchAnalysisController,
                    hintText: context.l10n.matchAnalysisHint,
                    maxLines: 6,
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: context.l10n.save,
                    isDisabled: isSaving,
                    onPressed: () async {
                      if (!validate()) return;

                      if (player1.value == null || player2.value == null || supervisor.value == null || dateTimeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.fillRequiredFields)),
                        );
                        return;
                      }

                      if (player1.value?.id == player2.value?.id) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.samePlayerError)),
                        );
                        return;
                      }

                      final match = MatchParams(
                        dateOfGame: dateTimeController.text,
                        lap: roundController.text.isEmpty ? null : roundController.text,
                        supervisorId: supervisor.value!.id,
                        homeTeamId: player1.value!.id,
                        awayTeamId: player2.value!.id,
                        leagueId: id!,
                        betting_tips: bettingTipsController.text,
                        match_analysis: matchAnalysisController.text,
                      );

                      final result = await createMatch(match);

                      if (result is DataSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.matchSavedSuccess)),
                        );
                        await context.router.replace(const MatchRoute());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.error)),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
