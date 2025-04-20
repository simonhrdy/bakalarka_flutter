import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/league/league_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';

@RoutePage()
class LeagueScreen extends HookWidget {
  const LeagueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final leagues = useState<List<LeagueModel>>([]);
    final filteredLeagues = useState<List<LeagueModel>>([]);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final searchController = useTextEditingController();
    final dataSource = useState<LeagueDataSource?>(null);

    late Future<void> Function() loadLeagues;

    void filterLeagues(String query) {
      final lower = query.toLowerCase();
      final filtered = leagues.value.where((league) {
        return league.name.toLowerCase().contains(lower);
      }).toList();

      filteredLeagues.value = filtered;

      dataSource.value = LeagueDataSource(
        context: context,
        leagues: filtered,
        onEdit: (league) async {
          await context.router.push(LeagueFormRoute(leagueId: league.id));
          await loadLeagues();
        },
        onDelete: (league) async {
          final result = await repository.deleteLeague(league.id);
          if (result is DataSuccess) {
            await loadLeagues();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.error)),
            );
          }
        },
      );
    }

    loadLeagues = () async {
      isLoading.value = true;
      error.value = null;

      final result = await repository.getLeagues();

      if (result is DataSuccess && result.data != null) {
        leagues.value = result.data!;
        filteredLeagues.value = result.data!;
        filterLeagues(searchController.text);
      } else {
        error.value = context.l10n.error;
      }

      isLoading.value = false;
    };

    useEffect(() {
      loadLeagues();
      return null;
    }, []);

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.createLeague,
              isDisabled: false,
              onPressed: () async {
                await context.router.push(LeagueFormRoute());
                await loadLeagues();
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: context.l10n.searchByLeagueName,
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
              onChanged: filterLeagues,
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

class LeagueDataSource extends DataTableSource {
  final List<LeagueModel> leagues;
  final BuildContext context;
  final void Function(LeagueModel league) onEdit;
  final void Function(LeagueModel league) onDelete;

  LeagueDataSource({
    required this.leagues,
    required this.context,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= leagues.length) return null;
    final league = leagues[index];

    return DataRow.byIndex(
      index: index,
      color: const WidgetStatePropertyAll(Colors.black),
      cells: [
        DataCell(Text(league.name, style: const TextStyle(color: Colors.white))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => onEdit(league),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => leagues.length;

  @override
  int get selectedRowCount => 0;
}
