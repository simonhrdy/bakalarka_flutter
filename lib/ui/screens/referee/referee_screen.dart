import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/referee/referee_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';

@RoutePage()
class RefereeScreen extends HookWidget {
  const RefereeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final referees = useState<List<RefereeModel>>([]);
    final filteredReferees = useState<List<RefereeModel>>([]);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final searchController = useTextEditingController();
    final dataSource = useState<RefereeDataSource?>(null);

    late Future<void> Function() loadReferees;

    void filterReferees(String query) {
      final lower = query.toLowerCase();
      final filtered = referees.value.where((referee) {
        return (referee.surname.toLowerCase().contains(lower)) ||
            referee.name.toLowerCase().contains(lower);
      }).toList();

      filteredReferees.value = filtered;

      dataSource.value = RefereeDataSource(
        context: context,
        referees: filtered,
        onEdit: (referee) async {
          await context.router.push(RefereeFormRoute(refereeId: referee.id));
          await loadReferees();
        },
        onDelete: (referee) async {
          final result = await repository.deleteReferee(referee.id);
          if (result is DataSuccess) {
            await loadReferees();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.error)),
            );
          }
        },
      );
    }

    loadReferees = () async {
      isLoading.value = true;
      error.value = null;

      final result = await repository.getReferees();

      if (result is DataSuccess && result.data != null) {
        referees.value = result.data!;
        filteredReferees.value = result.data!;
        filterReferees(searchController.text);
      } else {
        error.value = context.l10n.error;
      }

      isLoading.value = false;
    };

    useEffect(() {
      loadReferees();
      return null;
    }, []);

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Vytvořit rozhodčího',
              isDisabled: false,
              onPressed: () async {
                await context.router.push(RefereeFormRoute());
                await loadReferees();
              },
            ),
            const SizedBox(height: 30),
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Hledat podle jména nebo příjmení',
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
              onChanged: filterReferees,
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
                        DataColumn(label: Text(context.l10n.nameColumn, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.surnameColumn, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.actionColumn, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
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

class RefereeDataSource extends DataTableSource {
  final List<RefereeModel> referees;
  final BuildContext context;
  final void Function(RefereeModel referee) onEdit;
  final void Function(RefereeModel referee) onDelete;

  RefereeDataSource({
    required this.referees,
    required this.context,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= referees.length) return null;
    final referee = referees[index];

    return DataRow.byIndex(
      index: index,
      color: const WidgetStatePropertyAll(Colors.black),
      cells: [
        DataCell(Text(referee.name, style: const TextStyle(color: Colors.white))),
        DataCell(Text(referee.surname, style: const TextStyle(color: Colors.white))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => onEdit(referee),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => referees.length;

  @override
  int get selectedRowCount => 0;
}
