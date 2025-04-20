import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/season/season_team_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';

@RoutePage()
class SeasonAddTeamScreen extends HookWidget {
  const SeasonAddTeamScreen({
    @PathParam('seasonId') this.seasonId,
    super.key,
  });

  final int? seasonId;

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final assignedTeams = useState<List<SeasonTeamModel>>([]);

    Future<void> loadSeasonTeams() async {
      if (seasonId == null) return;

      final result = await repository.getSeasonTeamsById(seasonId!);
      if (result is DataSuccess && result.data != null) {
        assignedTeams.value = result.data!.seasonHasTeams ?? [];
      } else {
        error.value = context.l10n.error;
      }
      isLoading.value = false;
    }

    Future<void> deleteTeamFromSeason(int teamId) async {
       await repository.deleteSeasonTeam(seasonId!, teamId);
       await loadSeasonTeams();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tým byl smazán')),
      );
    }

    useEffect(() {
      loadSeasonTeams();
      return null;
    }, []);

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.addTeamsToSeason,
              isDisabled: false,
              onPressed: () async {
                await context.router.push(SeasonAddTeamFormRoute(seasonId: seasonId!));
                await loadSeasonTeams();
              },
            ),
            const SizedBox(height: 30),
            if (isLoading.value)
              const Center(child: CircularProgressIndicator())
            else if (error.value != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(error.value!, style: const TextStyle(color: Colors.red)),
              )
            else
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    cardColor: Colors.black,
                    canvasColor: Colors.black,
                    scaffoldBackgroundColor: Colors.black,
                    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black),
                    textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Colors.white,
                      displayColor: Colors.white,
                    ),
                    dataTableTheme: const DataTableThemeData(
                      dataRowColor: WidgetStatePropertyAll<Color>(Colors.black),
                    ),
                  ),
                  child: PaginatedDataTable2(
                    columns: [
                      DataColumn(label: Text(context.l10n.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(context.l10n.actionColumn, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                    ],
                    source: SeasonTeamsDataSource(
                      teams: assignedTeams.value,
                      onDelete: deleteTeamFromSeason,
                    ),
                    headingRowColor: const WidgetStatePropertyAll(Colors.white),
                    columnSpacing: 16,
                    horizontalMargin: 12,
                    minWidth: 400,
                    autoRowsToHeight: true,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SeasonTeamsDataSource extends DataTableSource {
  final List<SeasonTeamModel> teams;
  final void Function(int teamId) onDelete;

  SeasonTeamsDataSource({
    required this.teams,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= teams.length) return null;
    final team = teams[index];

    return DataRow.byIndex(
      index: index,
      color: const WidgetStatePropertyAll(Colors.black),
      cells: [
        DataCell(Text(team.name, style: const TextStyle(color: Colors.white))),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onDelete(team.id),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => teams.length;

  @override
  int get selectedRowCount => 0;
}
