import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/team/team_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';


@RoutePage()
class TeamScreen extends HookWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final teams = useState<List<TeamModel>>([]);
    final filteredTeams = useState<List<TeamModel>>([]);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final searchController = useTextEditingController();
    final dataSource = useState<TeamDataSource?>(null);

    late Future<void> Function() loadTeams;

    void filterTeams(String query) {
      final lower = query.toLowerCase();
      final filtered = teams.value.where((team) {
        return team.name.toLowerCase().contains(lower) ||
            (team.surname?.toLowerCase().contains(lower) ?? false) ||
            (team.nameShort?.toLowerCase().contains(lower) ?? false);
      }).toList();

      filteredTeams.value = filtered;

      dataSource.value = TeamDataSource(
        context: context,
        teams: filtered,
        onEdit: (team) async {
          await context.router.push(TeamFormRoute(teamId: team.id));
          await loadTeams();
        },
        onDelete: (team) async {
          final result = await repository.deleteTeam(team.id);
          if (result is DataSuccess) {
            await loadTeams();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.error)),
            );
          }
        },
      );
    }

    loadTeams = () async {
      isLoading.value = true;
      error.value = null;

      final result = await repository.getTeams();

      if (result is DataSuccess && result.data != null) {
        teams.value = result.data!;
        filteredTeams.value = result.data!;
        dataSource.value = TeamDataSource(
          context: context,
          teams: result.data!,
          onEdit: (team) async {
            await context.router.push(TeamFormRoute(teamId: team.id));
            await loadTeams();
          },
          onDelete: (team) async {
            final result = await repository.deleteTeam(team.id);
            if (result is DataSuccess) {
              await loadTeams();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(context.l10n.error)),
              );
            }
          },
        );
      } else {
        error.value = 'Nepodařilo se načíst týmy.';
      }

      isLoading.value = false;
    };

    useEffect(() {
      loadTeams();
      return null;
    }, []);

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.createTeam,
              isDisabled: false,
              onPressed: () async {
                await context.router.push(TeamFormRoute());
                await loadTeams();
              },
            ),
            const SizedBox(height:30),
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: context.l10n.searchTeamHint,
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: filterTeams,
            ),
            const SizedBox(height: 24),
            if (isLoading.value)
              const Center(child: CircularProgressIndicator())
            else if (error.value != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(error.value!, style: const TextStyle(color: Colors.red)),
              )
            else if (dataSource.value != null)
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      cardColor: Colors.black,
                      canvasColor: Colors.black,
                      scaffoldBackgroundColor: Colors.black,
                      bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black),
                      textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: Colors.black,
                        displayColor: Colors.black,
                      ),
                      dataTableTheme: const DataTableThemeData(
                        dataRowColor: WidgetStatePropertyAll<Color>(Colors.black),
                      ),
                    ),
                    child: PaginatedDataTable2(
                      columns: [
                        DataColumn(label: Text(context.l10n.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.surnameColumn, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.shortName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.actions, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                      ],
                      source: dataSource.value!,
                      headingRowColor: const WidgetStatePropertyAll(Colors.white),
                      columnSpacing: 16,
                      horizontalMargin: 12,
                      minWidth: 600,
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

class TeamDataSource extends DataTableSource {
  final List<TeamModel> teams;
  final BuildContext context;
  final void Function(TeamModel team) onEdit;
  final void Function(TeamModel team) onDelete;

  TeamDataSource({
    required this.teams,
    required this.context,
    required this.onEdit,
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
        DataCell(Text(team.surname ?? '', style: const TextStyle(color: Colors.white))),
        DataCell(Text(team.nameShort ?? '', style: const TextStyle(color: Colors.white))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => onEdit(team),
            ),
          ],
        )),
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
