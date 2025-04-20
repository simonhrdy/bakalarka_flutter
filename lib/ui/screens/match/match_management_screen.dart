import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/data/models/match/match_form_data.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/sport_forms/dart_form.dart';
import 'package:sportmatter/widgets/sport_forms/football_form.dart';
import 'package:sportmatter/widgets/sport_forms/hockey_form.dart';

@RoutePage()
class MatchManagementScreen extends HookWidget {
  const MatchManagementScreen({
    @PathParam('matchId') required this.matchId,
    super.key,
  });

  final int matchId;

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final isLoading = useState(true);
    final formData = useState<MatchFormData?>(null);

    useEffect(() {
      () async {
        final matchResult = await repository.getGameById(matchId);
        if (matchResult is! DataSuccess) {
          isLoading.value = false;
          return;
        }

        final match = matchResult.data!;
        final teamResult = await repository.getTeams();
        final userResult = await repository.getUsers();
        final bettingResult = await repository.getBetting(match.id);
        final analysisResult = await repository.getAnalysis(match.id);

        formData.value = MatchFormData(
          match: match,
          teams: teamResult is DataSuccess ? teamResult.data! : [],
          users: userResult is DataSuccess ? userResult.data! : [],
          betting: bettingResult is DataSuccess ? bettingResult.data : null,
          analysis: analysisResult is DataSuccess ? analysisResult.data : null,
        );

        isLoading.value = false;
      }();
      return null;
    }, []);

    if (isLoading.value) {
      return const MainScaffold(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (formData.value == null) {
      return MainScaffold(
        child: Center(child: Text(context.l10n.error, style: TextStyle(color: Colors.white))),
      );
    }

    final data = formData.value!;
    final sportUrl = data.match.sport?.toLowerCase() ?? '';

    Widget getFormWidget() {
      switch (sportUrl) {
        case 'sipky':
          return DartMatchFormScreen(
            match: data.match,
            teams: data.teams,
            users: data.users,
            betting: data.betting,
            analysis: data.analysis,
          );
        case 'hokej':
          return HockeyMatchFormScreen(
            match: data.match,
            teams: data.teams,
            users: data.users,
            betting: data.betting,
            analysis: data.analysis,
          );
        case 'fotbal':
          return FootballMatchFormScreen(
            match: data.match,
            teams: data.teams,
            users: data.users,
            betting: data.betting,
            analysis: data.analysis,
          );
        default:
          return Center(
            child: Text(context.l10n.error, style: TextStyle(color: Colors.white)),
          );
      }
    }

    return MainScaffold(
      child: getFormWidget(),
    );
  }
}
