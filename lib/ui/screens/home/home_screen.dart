import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sportmatter/config/extensions/extensions.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/match/match_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/hooks/user/use_current_user.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/date_selector/date_selector.dart';

@RoutePage()
class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = useCurrentUser();
    final repository = useApiRepository();

    final games = useState<List<MatchModel>>([]);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final selectedDate = useState<DateTime>(DateTime.now());

    Future<void> loadGames() async {
      final userId = currentUser?.id;
      if (userId == null) {
        error.value = context.l10n.error;
        isLoading.value = false;
        return;
      }

      isLoading.value = true;
      error.value = null;

      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value);
      final result = await repository.getGamesBySuperVisor(userId, dateStr);

      if (result is DataSuccess && result.data != null) {
        games.value = result.data!;
      } else {
        error.value = context.l10n.error;
      }

      isLoading.value = false;
    }

    useEffect(() {
      loadGames();
      return null;
    }, [selectedDate.value]);

    return MainScaffold(
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isLoading.value)
                            const Center(child: CircularProgressIndicator())
                          else if (error.value != null)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                error.value!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                          else if (games.value.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  context.l10n.noGamesToday,
                                  style: context.textTheme.h2,
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: games.value.length,
                                itemBuilder: (context, index) {
                                  final game = games.value[index];

                                  final homeName = game.homeTeamName ?? context.l10n.homeTeam;
                                  final awayName = game.awayTeamName ?? context.l10n.awayTeam;
                                  final homeLogo = game.homeTeamImage;
                                  final awayLogo = game.awayTeamImage;
                                  final date = game.formattedDateCz;
                                  final statusLabel = game.statusLabel;
                                  final league = game.leagueName ?? context.l10n.unknownLeague;

                                  Color getStatusColor() {
                                    switch (game.status) {
                                      case 1:
                                        return Colors.green;
                                      case 0:
                                      default:
                                        return Colors.grey;
                                    }
                                  }

                                  return Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                      const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                                      title: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            if (homeLogo != null)
                                              Image.network(
                                                homeLogo,
                                                width: 24,
                                                height: 24,
                                                errorBuilder: (context, error, stackTrace) =>
                                                const SizedBox.shrink(),
                                              ),
                                            const SizedBox(width: 6),
                                            Text(homeName, style: context.textTheme.body),
                                            const SizedBox(width: 6),
                                            Text(context.l10n.vs, style: context.textTheme.body),
                                            const SizedBox(width: 6),
                                            if (awayLogo != null)
                                              Image.network(
                                                awayLogo,
                                                width: 24,
                                                height: 24,
                                                errorBuilder: (context, error, stackTrace) =>
                                                const SizedBox.shrink(),
                                              ),
                                            const SizedBox(width: 6),
                                            Text(awayName, style: context.textTheme.body),
                                          ],
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text('${context.l10n.date}: $date',
                                              style: context.textTheme.body),
                                          const SizedBox(height: 2),
                                          Text('${context.l10n.league}: $league',
                                              style: context.textTheme.body),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: getStatusColor()
                                                  .withAlpha((0.1 * 255).toInt()),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              statusLabel,
                                              style: context.textTheme.body.copyWith(
                                                color: getStatusColor(),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.settings, color: Colors.white),
                                        onPressed: () {
                                          context.router
                                              .replace(MatchManagementRoute(matchId: game.id));
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          DateSelector(
            initialDate: selectedDate.value,
            onDateChanged: (date) => selectedDate.value = date,
          ),
        ],
      ),
    );
  }
}
