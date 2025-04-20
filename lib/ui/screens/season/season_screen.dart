import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/season/season_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';

@RoutePage()
class SeasonScreen extends HookWidget {
  const SeasonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final seasons = useState<List<SeasonModel>>([]);
    final filteredSeasons = useState<List<SeasonModel>>([]);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final searchController = useTextEditingController();
    final dataSource = useState<SeasonDataSource?>(null);

    late Future<void> Function() loadSeasons;

    void filterSeasons(String query) {
      final lower = query.toLowerCase();
      final filtered = seasons.value.where((season) {
        return season.leagueName?.toLowerCase().contains(lower) ?? false;
      }).toList();

      filteredSeasons.value = filtered;

      dataSource.value = SeasonDataSource(
        context: context,
        seasons: filtered,
        onEdit: (season) async {
          await context.router.push(SeasonFormRoute(seasonId: season.id));
          await loadSeasons();
        },
        onDelete: (season) async {
          final result = await repository.deleteSeason(season.id);
          if (result is DataSuccess) {
            await loadSeasons();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(context.l10n.error)),
            );
          }
        },
      );
    }

    loadSeasons = () async {
      isLoading.value = true;
      error.value = null;

      final result = await repository.getSeasons();

      if (result is DataSuccess && result.data != null) {
        seasons.value = result.data!;
        filteredSeasons.value = result.data!;
        filterSeasons(searchController.text);
      } else {
        error.value = context.l10n.error;
      }

      isLoading.value = false;
    };

    useEffect(() {
      loadSeasons();
      return null;
    }, []);

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.createSeason,
              isDisabled: false,
              onPressed: () async {
                await context.router.push(SeasonFormRoute());
                await loadSeasons();
              },
            ),
            const SizedBox(height: 30),
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: context.l10n.searchByLeague,
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
              onChanged: filterSeasons,
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
                      columns:  [
                        DataColumn(label: Text(context.l10n.league, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.seasonPeriod, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.active, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.actions, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
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

class SeasonDataSource extends DataTableSource {
  final List<SeasonModel> seasons;
  final BuildContext context;
  final void Function(SeasonModel season) onEdit;
  final void Function(SeasonModel season) onDelete;

  SeasonDataSource({
    required this.seasons,
    required this.context,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= seasons.length) return null;
    final season = seasons[index];

    return DataRow.byIndex(
      index: index,
      color: const WidgetStatePropertyAll(Colors.black),
      cells: [
        DataCell(Text(season.leagueName ?? 'N/A', style: const TextStyle(color: Colors.white))),
        DataCell(Text(
          '${season.yearStart?.year ?? '-'} / ${season.yearEnd?.year ?? '-'}',
          style: const TextStyle(color: Colors.white),
        )),
        DataCell(Icon(
          season.isActive ? Icons.check_circle : Icons.cancel,
          color: season.isActive ? Colors.green : Colors.red,
        )),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => onEdit(season),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.greenAccent),
              tooltip: context.l10n.addTeamsToSeason,
              onPressed: () => context.router.replace(
                SeasonAddTeamRoute(seasonId: season.id),
              ),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => seasons.length;

  @override
  int get selectedRowCount => 0;
}
