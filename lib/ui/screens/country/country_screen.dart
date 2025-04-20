import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/country/country_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';

@RoutePage()
class CountryScreen extends HookWidget {
  const CountryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final countries = useState<List<CountryModel>>([]);
    final filteredCountries = useState<List<CountryModel>>([]);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final searchController = useTextEditingController();
    final dataSource = useState<CountryDataSource?>(null);

    late Future<void> Function() loadCountries;

    void filterCountries(String query) {
      final lower = query.toLowerCase();
      final filtered = countries.value.where((country) {
        return (country.name?.toLowerCase().contains(lower) ?? false) ||
            (country.nameShort?.toLowerCase().contains(lower) ?? false);
      }).toList();

      filteredCountries.value = filtered;

      dataSource.value = CountryDataSource(
        context: context,
        countries: filtered,
        onEdit: (country) async {
          await context.router.push(CountryFormRoute(countryId: country.id));
          await loadCountries();
        },
        onDelete: (country) async {
          final result = await repository.deleteCountry(country.id ?? 0);
          if (result is DataSuccess) {
            await loadCountries();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.error)),
            );
          }
        },
      );
    }

    loadCountries = () async {
      isLoading.value = true;
      error.value = null;

      final result = await repository.getCountries();

      if (result is DataSuccess && result.data != null) {
        countries.value = result.data!;
        filteredCountries.value = result.data!;
        filterCountries(searchController.text);
      } else {
        error.value = context.l10n.error;
      }

      isLoading.value = false;
    };

    useEffect(() {
      loadCountries();
      return null;
    }, []);

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.createCountry,
              isDisabled: false,
              onPressed: () async {
                await context.router.push(CountryFormRoute());
                await loadCountries();
              },
            ),
            const SizedBox(height: 30),
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: context.l10n.searchByCountry,
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
              onChanged: filterCountries,
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
                        DataColumn(label: Text(context.l10n.nameColumn, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.shortName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
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

class CountryDataSource extends DataTableSource {
  final List<CountryModel> countries;
  final BuildContext context;
  final void Function(CountryModel country) onEdit;
  final void Function(CountryModel country) onDelete;

  CountryDataSource({
    required this.countries,
    required this.context,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= countries.length) return null;
    final country = countries[index];

    return DataRow.byIndex(
      index: index,
      color: const WidgetStatePropertyAll(Colors.black),
      cells: [
        DataCell(Text(country.name ?? context.l10n.unknownCountry, style: const TextStyle(color: Colors.white))),
        DataCell(Text(country.nameShort ?? '-', style: const TextStyle(color: Colors.white))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => onEdit(country),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => countries.length;

  @override
  int get selectedRowCount => 0;
}
