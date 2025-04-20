import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/stadium/stadium_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';

@RoutePage()
class StadiumScreen extends HookWidget {
  const StadiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final stadiums = useState<List<StadiumModel>>([]);
    final filteredStadiums = useState<List<StadiumModel>>([]);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final searchController = useTextEditingController();
    final dataSource = useState<StadiumDataSource?>(null);

    late Future<void> Function() loadStadiums;

    void filterStadiums(String query) {
      final lower = query.toLowerCase();
      final filtered = stadiums.value.where((stadium) {
        return stadium.name.toLowerCase().contains(lower);
      }).toList();

      filteredStadiums.value = filtered;

      dataSource.value = StadiumDataSource(
        context: context,
        stadiums: filtered,
        onEdit: (stadium) async {
          await context.router.push(StadiumFormRoute(stadiumId: stadium.id));
          await loadStadiums();
        },
        onDelete: (stadium) async {
          final result = await repository.deleteStadium(stadium.id);
          if (result is DataSuccess) {
            await loadStadiums();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(context.l10n.error)),
            );
          }
        },
      );
    }

    loadStadiums = () async {
      isLoading.value = true;
      error.value = null;

      final result = await repository.getStadiums();

      if (result is DataSuccess && result.data != null) {
        stadiums.value = result.data!;
        filteredStadiums.value = result.data!;
        dataSource.value = StadiumDataSource(
          context: context,
          stadiums: result.data!,
          onEdit: (stadium) async {
            await context.router.push(StadiumFormRoute(stadiumId: stadium.id));
            await loadStadiums();
          },
          onDelete: (stadium) async {
            final result = await repository.deleteStadium(stadium.id);
            if (result is DataSuccess) {
              await loadStadiums();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(context.l10n.error)),
              );
            }
          },
        );
      } else {
        error.value = context.l10n.error;
      }

      isLoading.value = false;
    };

    useEffect(() {
      loadStadiums();
      return null;
    }, []);

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.createStadium,
              isDisabled: false,
              onPressed: () async {
                await context.router.push(StadiumFormRoute());
                await loadStadiums();
              },
            ),
            const SizedBox(height: 30),
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: context.l10n.searchByStadiumName,
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
              onChanged: filterStadiums,
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
                        DataColumn(label: Text(context.l10n.stadiumFormCapacity, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
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

class StadiumDataSource extends DataTableSource {
  final List<StadiumModel> stadiums;
  final BuildContext context;
  final void Function(StadiumModel stadium) onEdit;
  final void Function(StadiumModel stadium) onDelete;

  StadiumDataSource({
    required this.stadiums,
    required this.context,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= stadiums.length) return null;
    final stadium = stadiums[index];

    return DataRow.byIndex(
      index: index,
      color: const WidgetStatePropertyAll(Colors.black),
      cells: [
        DataCell(Text(stadium.name, style: const TextStyle(color: Colors.white))),
        DataCell(Text(stadium.capacity?.toString() ?? '-', style: const TextStyle(color: Colors.white))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => onEdit(stadium),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => stadiums.length;

  @override
  int get selectedRowCount => 0;
}
