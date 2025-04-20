import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/match/match_analysis_model.dart';
import 'package:sportmatter/data/models/match/match_betting_model.dart';
import 'package:sportmatter/data/models/match/match_model.dart';
import 'package:sportmatter/data/models/player/player_model.dart';
import 'package:sportmatter/data/models/team/team_model.dart';
import 'package:sportmatter/data/models/user/user_model.dart';
import 'package:sportmatter/data/params/match/match_params.dart';
import 'package:sportmatter/data/params/player/player_action_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/widgets/button/button.dart';
import 'package:sportmatter/widgets/form/form_builder.dart';
import 'package:sportmatter/widgets/form/line_up_selector.dart';
import 'package:sportmatter/widgets/form/match_date_and_round_fields.dart';
import 'package:sportmatter/widgets/form/match_status_and_supervisor_fields.dart';
import 'package:sportmatter/widgets/form/player_action_inputs.dart';
import 'package:sportmatter/widgets/form/text_field.dart';
import 'package:sportmatter/widgets/responsive/responsive_row_column.dart';

class HockeyMatchFormScreen extends HookWidget {
  const HockeyMatchFormScreen({
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
    final isLoading = useState(true);

    final focusNodes =
        useMemoized(() => List.generate(10, (_) => FocusNode()), []);
    final dateTimeController = useTextEditingController();
    final roundController =
        useTextEditingController(text: match.lap?.toString() ?? '');
    final status = useState<int>(match.status ?? 0);

    final team1 = useState<TeamModel?>(
        teams.firstWhereOrNull((t) => t.id == match.homeTeamId),);
    final team2 = useState<TeamModel?>(
        teams.firstWhereOrNull((t) => t.id == match.awayTeamId),);
    final supervisor = useState<UserModel?>(
        users.firstWhereOrNull((u) => u.id == match.supervisor),);

    final goals1 = useTextEditingController(
        text: match.parametrs?['hockey_count_of_goals_home_team'] as String? ??
            '',);
    final shootingSuccess1 = useTextEditingController(
        text: match.parametrs?['hockey_shooting_succes_home_team'] as String? ??
            '',);
    final shotsOnGoal1 = useTextEditingController(
        text: match.parametrs?['hockey_number_of_shots_on_goal_home_team']
                as String? ??
            '',);
    final numberOfGoals1 = useTextEditingController(
        text: match.parametrs?['hockey_number_of_goal_home_team'] as String? ??
            '',);
    final exclusions1 = useTextEditingController(
        text: match.parametrs?['hockey_number_of_exlusion_home_team']
                as String? ??
            '',);

    final goals2 = useTextEditingController(
        text: match.parametrs?['hockey_count_of_goals_away_team'] as String? ??
            '');
    final shootingSuccess2 = useTextEditingController(
        text: match.parametrs?['hockey_shooting_succes_away_team'] as String? ??
            '');
    final shotsOnGoal2 = useTextEditingController(
        text: match.parametrs?['hockey_number_of_shots_on_goal_away_team']
                as String? ??
            '');
    final numberOfGoals2 = useTextEditingController(
        text: match.parametrs?['hockey_number_of_goal_away_team'] as String? ??
            '');
    final exclusions2 = useTextEditingController(
        text: match.parametrs?['hockey_number_of_exlusion_away_team']
                as String? ??
            '');

    final bettingTipsController =
        useTextEditingController(text: betting?.content ?? '');
    final matchAnalysisController =
        useTextEditingController(text: analysis?.content ?? '');

    final allPlayersTeam1 = useState<List<PlayerModel>>([]);
    final allPlayersTeam2 = useState<List<PlayerModel>>([]);
    final lineTeam1 = useState<List<PlayerModel>>([]);
    final reservesTeam1 = useState<List<PlayerModel>>([]);
    final lineTeam2 = useState<List<PlayerModel>>([]);
    final reservesTeam2 = useState<List<PlayerModel>>([]);

    final actionsHome = useState<List<PlayerAction>>([PlayerAction()]);
    final actionsAway = useState<List<PlayerAction>>([PlayerAction()]);

    final parsedDate = match.date is String
        ? DateTime.tryParse(match.date as String)
        : match.date;

    if (parsedDate != null) {
      dateTimeController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(parsedDate);
    }

    useEffect(() {
      () async {
        if (team1.value != null) {
          final res = await repository.getPlayersTeam(team1.value!.id);
          if (res is DataSuccess) allPlayersTeam1.value = res.data!;
        }

        if (team2.value != null) {
          final res = await repository.getPlayersTeam(team2.value!.id);
          if (res is DataSuccess) allPlayersTeam2.value = res.data!;
        }

        final resLineup = await repository.getLineup(match.id);
        if (resLineup is DataSuccess) {
          final lineups = resLineup.data!;
          final homeId = match.homeTeamId;
          final awayId = match.awayTeamId;

          lineTeam1.value = lineups
              .where((l) => l.idTeam == homeId && l.is_starter)
              .map((l) => PlayerModel(
                  id: l.idPlayer, name: l.firstName!, surname: l.lastName))
              .toList();
          reservesTeam1.value = lineups
              .where((l) => l.idTeam == homeId && !l.is_starter)
              .map((l) => PlayerModel(
                  id: l.idPlayer, name: l.firstName!, surname: l.lastName))
              .toList();
          lineTeam2.value = lineups
              .where((l) => l.idTeam == awayId && l.is_starter)
              .map((l) => PlayerModel(
                  id: l.idPlayer, name: l.firstName!, surname: l.lastName))
              .toList();
          reservesTeam2.value = lineups
              .where((l) => l.idTeam == awayId && !l.is_starter)
              .map((l) => PlayerModel(
                  id: l.idPlayer, name: l.firstName!, surname: l.lastName))
              .toList();
        }

        final parsedActions = match.parametrs?['actions'];
        if (parsedActions != null) {
          final decoded = parsedActions is String
              ? jsonDecode(parsedActions)
              : parsedActions;
          if (decoded is List) {
            final home = <PlayerAction>[];
            final away = <PlayerAction>[];
            for (final a in decoded) {
              if (a is Map<String, dynamic>) {
                final action = PlayerAction(
                  playerId: a['id'] as int?,
                  playerName: a['name'] as String?,
                  type: a['type'] as int?,
                  minute: a['minute'] as int?,
                );
                if (a['team'] == 'home') home.add(action);
                if (a['team'] == 'away') away.add(action);
              }
            }
            actionsHome.value = home.isEmpty ? [PlayerAction()] : home;
            actionsAway.value = away.isEmpty ? [PlayerAction()] : away;
          }
        }

        isLoading.value = false;
      }();
      return null;
    }, [team1.value, team2.value]);

    if (isLoading.value) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }

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
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                ResponsiveRowOrColumn(
                  spacing: 16,
                  children: [
                    Column(
                      children: [
                        Text(context.l10n.team1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(team1.value?.name ?? '', style: context.textTheme.h1),
                        const SizedBox(height: 25),
                        Text(context.l10n.actions_goal, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        FormTextField(controller: goals1, hintText: context.l10n.actions_goal),
                        const SizedBox(height: 15),
                        Text(context.l10n.shootingSuccess, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        FormTextField(controller: shootingSuccess1, hintText: context.l10n.shootingSuccess),
                        const SizedBox(height: 15),
                        Text(context.l10n.shotsOnGoal, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        FormTextField(controller: shotsOnGoal1, hintText: context.l10n.shotsOnGoal),
                        const SizedBox(height: 15),
                        Text(context.l10n.numberOfGoals, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        FormTextField(controller: numberOfGoals1, hintText: context.l10n.numberOfGoals),
                        const SizedBox(height: 15),
                        Text(context.l10n.numberOfExclusions, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        FormTextField(controller: exclusions1, hintText: context.l10n.numberOfExclusions),
                      ],
                    ),
                    Column(
                      children: [
                        Text(context.l10n.team2, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(team2.value?.name ?? '', style: context.textTheme.h1),
                        const SizedBox(height: 25),
                        Text(context.l10n.actions_goal, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        FormTextField(controller: goals2, hintText: context.l10n.actions_goal),
                        const SizedBox(height: 15),
                        Text(context.l10n.shootingSuccess, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        FormTextField(controller: shootingSuccess2, hintText: context.l10n.shootingSuccess),
                        const SizedBox(height: 15),
                        Text(context.l10n.shotsOnGoal, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        FormTextField(controller: shotsOnGoal2, hintText: context.l10n.shotsOnGoal),
                        const SizedBox(height: 15),
                        Text(context.l10n.numberOfGoals, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        FormTextField(controller: numberOfGoals2, hintText: context.l10n.numberOfGoals),
                        const SizedBox(height: 15),
                        Text(context.l10n.numberOfExclusions, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 10),
                        FormTextField(controller: exclusions2, hintText: context.l10n.numberOfExclusions),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ...[
                  [context.l10n.form_line_up, lineTeam1, lineTeam2],
                  [context.l10n.form_line_up_bench_, reservesTeam1, reservesTeam2],
                ].map((entry) {
                  final label = entry[0] as String;
                  final home = entry[1] as ValueNotifier<List<PlayerModel>>;
                  final away = entry[2] as ValueNotifier<List<PlayerModel>>;
                  return LineupSelector(
                    label: label,
                    playersTeam1: allPlayersTeam1.value,
                    playersTeam2: allPlayersTeam2.value,
                    selectedTeam1: home,
                    selectedTeam2: away,
                  );
                }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text(context.l10n.action_headline_home_team,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    PlayerActionInputs(
                      actionsList: actionsHome,
                      playerList: allPlayersTeam1.value,
                      team: 'home',
                      actionTypeItems: [
                        DropdownMenuItem(value: 1, child: Text(context.l10n.actions_goal)),
                        DropdownMenuItem(value: 2, child: Text(context.l10n.action_2_minute_penalty)),
                        DropdownMenuItem(value: 3, child: Text(context.l10n.action_5_minute_penalty)),
                        DropdownMenuItem(value: 4, child: Text(context.l10n.action_five_plus_ten_minute_penalty)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(context.l10n.action_headline_away_team,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    PlayerActionInputs(
                      actionsList: actionsAway,
                      playerList: allPlayersTeam2.value,
                      team: 'away',
                      actionTypeItems: [
                        DropdownMenuItem(value: 1, child: Text(context.l10n.actions_goal)),
                        DropdownMenuItem(value: 2, child: Text(context.l10n.action_2_minute_penalty)),
                        DropdownMenuItem(value: 3, child: Text(context.l10n.action_5_minute_penalty)),
                        DropdownMenuItem(value: 4, child: Text(context.l10n.action_five_plus_ten_minute_penalty)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: context.l10n.submit_put,
                  onPressed: () async {
                    if (dateTimeController.text.isEmpty ||
                        team1.value == null ||
                        team2.value == null ||
                        supervisor.value == null ||
                        team1.value!.id == team2.value!.id) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.form_empty_fields_error)),
                      );
                      return;
                    }

                    final statistics = {
                      'hockey_count_of_goals_home_team': goals1.text,
                      'hockey_shooting_succes_home_team': shootingSuccess1.text,
                      'hockey_number_of_shots_on_goal_home_team': shotsOnGoal1.text,
                      'hockey_number_of_goal_home_team': numberOfGoals1.text,
                      'hockey_number_of_exlusion_home_team': exclusions1.text,
                      'hockey_count_of_goals_away_team': goals2.text,
                      'hockey_shooting_succes_away_team': shootingSuccess2.text,
                      'hockey_number_of_shots_on_goal_away_team': shotsOnGoal2.text,
                      'hockey_number_of_goal_away_team': numberOfGoals2.text,
                      'hockey_number_of_exlusion_away_team': exclusions2.text,
                    };

                    final allActions = [
                      ...actionsHome.value
                          .where((a) => a.playerName?.trim().isNotEmpty ?? false)
                          .map((a) => {
                        'id': a.playerId,
                        'name': a.playerName!,
                        'team': 'home',
                        'type': a.type ?? 1,
                        'minute': a.minute ?? 0,
                      }),
                      ...actionsAway.value
                          .where((a) => a.playerName?.trim().isNotEmpty ?? false)
                          .map((a) => {
                        'id': a.playerId,
                        'name': a.playerName!,
                        'team': 'away',
                        'type': a.type ?? 1,
                        'minute': a.minute ?? 0,
                      }),
                    ];

                    statistics['actions'] = jsonEncode(allActions);

                    final lineUpHome = [
                      ...lineTeam1.value.map((p) => {'id': p.id, 'is_starter': 1}),
                      ...reservesTeam1.value.map((p) => {'id': p.id, 'is_starter': 0}),
                    ];

                    final lineUpAway = [
                      ...lineTeam2.value.map((p) => {'id': p.id, 'is_starter': 1}),
                      ...reservesTeam2.value.map((p) => {'id': p.id, 'is_starter': 0}),
                    ];

                    final params = MatchParams(
                      dateOfGame: dateTimeController.text,
                      lap: roundController.text.isEmpty ? null : roundController.text,
                      status: status.value,
                      supervisorId: supervisor.value?.id,
                      homeTeamId: team1.value!.id,
                      awayTeamId: team2.value!.id,
                      leagueId: match.leagueId,
                      statistics: statistics,
                      lineUpAway: lineUpAway,
                      lineUpHome: lineUpHome,
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
