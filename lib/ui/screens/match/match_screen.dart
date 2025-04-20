import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/match/match_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';

@RoutePage()
class MatchScreen extends HookWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final matches = useState<List<MatchModel>>([]);
    final filteredMatches = useState<List<MatchModel>>([]);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final searchController = useTextEditingController();
    final dataSource = useState<MatchDataSource?>(null);

    late Future<void> Function() loadMatches;

    void filterMatches(String query) {
      final lower = query.toLowerCase();
      final filtered = matches.value.where((match) {
        return (match.homeTeamName?.toLowerCase().contains(lower) ?? false) ||
            (match.awayTeamName?.toLowerCase().contains(lower) ?? false);
      }).toList();

      filteredMatches.value = filtered;

      dataSource.value = MatchDataSource(
        context: context,
        matches: filtered,
        onEdit: (match) async {
          await context.router.replace(MatchManagementRoute(matchId: match.id));
          await loadMatches();
        },
        onDelete: (match) async {
        },
      );
    }

    loadMatches = () async {
      isLoading.value = true;
      error.value = null;

      final result = await repository.getGames();

      if (result is DataSuccess && result.data != null) {
        matches.value = result.data!;
        filteredMatches.value = result.data!;
        filterMatches(searchController.text);
      } else {
        error.value = context.l10n.error;
      }

      isLoading.value = false;
    };

    useEffect(() {
      loadMatches();
      return null;
    }, []);

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.createMatch,
              isDisabled: false,
              onPressed: () async {
                await context.router.push(const SelectLeagueRoute());
                await loadMatches();
              },
            ),
            const SizedBox(height: 30),
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: context.l10n.searchByTeams,
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
              onChanged: filterMatches,
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
                        DataColumn(label: Text(context.l10n.matchColumn, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.dateColumn, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.actionColumn, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
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

class MatchDataSource extends DataTableSource {
  final List<MatchModel> matches;
  final BuildContext context;
  final void Function(MatchModel match) onEdit;
  final void Function(MatchModel match) onDelete;

  MatchDataSource({
    required this.matches,
    required this.context,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= matches.length) return null;
    final match = matches[index];

    return DataRow.byIndex(
      index: index,
      color: const WidgetStatePropertyAll(Colors.black),
      cells: [
        DataCell(Text(
          '${match.homeTeamName ?? context.l10n.team} vs ${match.awayTeamName ?? context.l10n.team}',
          style: const TextStyle(color: Colors.white),
        )),
        DataCell(Text(
          match.formattedDateCz,
          style: const TextStyle(color: Colors.white),
        )),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => onEdit(match),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => matches.length;

  @override
  int get selectedRowCount => 0;
}
