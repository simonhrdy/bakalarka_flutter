import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/match/match_analysis_model.dart';
import 'package:sportmatter/data/models/match/match_betting_model.dart';
import 'package:sportmatter/data/models/match/match_model.dart';
import 'package:sportmatter/data/models/team/team_model.dart';
import 'package:sportmatter/data/models/user/user_model.dart';
import 'package:sportmatter/data/params/match/match_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/match_date_and_round_fields.dart';
import 'package:sportmatter/widgets/form/match_status_and_supervisor_fields.dart';
import 'package:sportmatter/widgets/form/text_field.dart';
import 'package:collection/collection.dart';
import 'package:sportmatter/widgets/responsive/responsive_row_column.dart';

class DartMatchFormScreen extends HookWidget {
  const DartMatchFormScreen({
    required this.match,
    required this.teams,
    required this.users,
    this.betting,
    this.analysis,
    super.key,
  });

  final MatchModel match;
  final List<TeamModel> teams;
  final List<UserModel> users;
  final MatchBettingModel? betting;
  final MatchAnalysisModel? analysis;

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();

    final focusNodes = useMemoized(() => List.generate(10, (_) => FocusNode()), []);
    final dateTimeController = useTextEditingController();
    final roundController = useTextEditingController();
    final status = useState<int>(match.status ?? 0);

    final player1 = useState<TeamModel?>(teams.firstWhereOrNull((t) => t.id == match.homeTeamId));
    final player2 = useState<TeamModel?>(teams.firstWhereOrNull((t) => t.id == match.awayTeamId));
    final supervisor = useState<UserModel?>(users.firstWhereOrNull((u) => u.id == match.supervisor));

    final sets1 = useTextEditingController(text: match.parametrs?['count_of_sets_first_player'] as String? ?? '');
    final legs1 = useTextEditingController(text: match.parametrs?['count_of_legs_first_player'] as String? ?? '');
    final avg1  = useTextEditingController(text: match.parametrs?['average_first_player'] as String? ?? '');

    final sets2 = useTextEditingController(text: match.parametrs?['count_of_sets_second_player'] as String? ?? '');
    final legs2 = useTextEditingController(text: match.parametrs?['count_of_legs_second_player'] as String? ?? '');
    final avg2  = useTextEditingController(text: match.parametrs?['average_second_player'] as String? ?? '');

    final bettingTipsController = useTextEditingController(text: betting?.content ?? '');
    final matchAnalysisController = useTextEditingController(text: analysis?.content ?? '');

    final parsedDate = match.date is String
        ? DateTime.tryParse(match.date as String)
        : match.date;

    if (parsedDate != null) {
      dateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(parsedDate);
    }

    roundController.text = match.lap?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        focusNodes: focusNodes,
        builder: (context, validate) {
          return SingleChildScrollView(
            child: Column(
              children: [
                MatchDateAndRoundFields(
                  dateTimeController: dateTimeController,
                  roundController: roundController,
                ),
                const SizedBox(height: 35),
                MatchStatusAndSupervisorFields(
                  status: status,
                  supervisor: supervisor,
                  users: users,
                ),
                const SizedBox(height: 32),
                Text(context.l10n.bettingTips,
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                FormTextField(
                  controller: bettingTipsController,
                  hintText: context.l10n.bettingTipsHint,
                  maxLines: 6,
                ),
                const SizedBox(height: 24),
                Text(context.l10n.matchAnalysis,
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                FormTextField(
                  controller: matchAnalysisController,
                  hintText: context.l10n.matchAnalysisHint,
                  maxLines: 6,
                ),
                const SizedBox(height: 32),
                ResponsiveRowOrColumn(
                  children: [
                    Column(
                      children: [
                        Text(context.l10n.player1,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(
                          '${player1.value?.name ?? ''} ${player1.value?.surname ?? ''}',
                          style: context.textTheme.h1,
                        ),
                        const SizedBox(height: 25),
                        FormTextField(
                            controller: sets1,
                            hintText: context.l10n.dart_sets_player1),
                        const SizedBox(height: 15),
                        FormTextField(
                            controller: legs1,
                            hintText: context.l10n.dart_legs_player1),
                        const SizedBox(height: 15),
                        FormTextField(
                            controller: avg1,
                            hintText: context.l10n.dart_avg_player1),
                      ],
                    ),
                    Column(
                      children: [
                        Text(context.l10n.player2,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(
                          '${player2.value?.name ?? ''} ${player2.value?.surname ?? ''}',
                          style: context.textTheme.h1,
                        ),
                        const SizedBox(height: 25),
                        FormTextField(
                            controller: sets2,
                            hintText: context.l10n.dart_sets_player2),
                        const SizedBox(height: 15),
                        FormTextField(
                            controller: legs2,
                            hintText: context.l10n.dart_legs_player2),
                        const SizedBox(height: 15),
                        FormTextField(
                            controller: avg2,
                            hintText: context.l10n.dart_avg_player2),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: context.l10n.submit_put,
                  onPressed: () async {
                    if (dateTimeController.text.isEmpty ||
                        player1.value == null ||
                        player2.value == null ||
                        supervisor.value == null ||
                        player1.value!.id == player2.value!.id) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.l10n.form_players_fields_error),
                        ),
                      );
                      return;
                    }

                    final statistics = {
                      'count_of_sets_first_player': sets1.text,
                      'count_of_legs_first_player': legs1.text,
                      'average_first_player': avg1.text,
                      'count_of_sets_second_player': sets2.text,
                      'count_of_legs_second_player': legs2.text,
                      'average_second_player': avg2.text,
                    };

                    final params = MatchParams(
                      dateOfGame: dateTimeController.text,
                      lap: roundController.text.isEmpty
                          ? null
                          : roundController.text,
                      status: status.value,
                      supervisorId: supervisor.value?.id,
                      homeTeamId: player1.value!.id,
                      awayTeamId: player2.value!.id,
                      leagueId: match.leagueId,
                      statistics: statistics,
                      betting_tips: bettingTipsController.text,
                      match_analysis: matchAnalysisController.text,
                    );

                    final result = await repository.updateGame(match.id, params);

                    if (result is DataSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.hockey_success)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.hockey_error)),
                      );
                    }

                    await context.router.replace(const HomeRoute());
                  },
                  isDisabled: false,
                ),
              ],
            ),
          );
        },
      ),
    );


  }
}
