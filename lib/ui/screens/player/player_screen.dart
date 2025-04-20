import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/player/player_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';

@RoutePage()
class PlayerScreen extends HookWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final players = useState<List<PlayerModel>>([]);
    final filteredPlayers = useState<List<PlayerModel>>([]);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final searchController = useTextEditingController();
    final dataSource = useState<PlayerDataSource?>(null);

    late Future<void> Function() loadPlayers;

    void filterPlayers(String query) {
      final lower = query.toLowerCase();
      final filtered = players.value.where((player) {
        return player.name.toLowerCase().contains(lower) ||
            (player.surname?.toLowerCase().contains(lower) ?? false) ||
            (player.position?.toLowerCase().contains(lower) ?? false);
      }).toList();

      filteredPlayers.value = filtered;

      dataSource.value = PlayerDataSource(
        context: context,
        players: filtered,
        onEdit: (player) async {
          await context.router.push(PlayerFormRoute(playerId: player.id));
          await loadPlayers();
        },
        onDelete: (player) async {
          final result = await repository.deletePlayer(player.id);
          if (result is DataSuccess) {
            await loadPlayers();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.error)),
            );
          }
        },
      );
    }

    loadPlayers = () async {
      isLoading.value = true;
      error.value = null;

      final result = await repository.getPlayers();

      if (result is DataSuccess && result.data != null) {
        players.value = result.data!;
        filteredPlayers.value = result.data!;
        filterPlayers(searchController.text);
      } else {
        error.value = context.l10n.error;
      }

      isLoading.value = false;
    };

    useEffect(() {
      loadPlayers();
      return null;
    }, []);

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.createPlayer,
              isDisabled: false,
              onPressed: () async {
                await context.router.push(PlayerFormRoute());
                await loadPlayers();
              },
            ),
            const SizedBox(height: 30),
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: context.l10n.searchHintPlayer,
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
              onChanged: filterPlayers,
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
                        DataColumn(label: Text(context.l10n.position, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
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

class PlayerDataSource extends DataTableSource {
  final List<PlayerModel> players;
  final BuildContext context;
  final void Function(PlayerModel player) onEdit;
  final void Function(PlayerModel player) onDelete;

  PlayerDataSource({
    required this.players,
    required this.context,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= players.length) return null;
    final player = players[index];

    return DataRow.byIndex(
      index: index,
      color: const WidgetStatePropertyAll(Colors.black),
      cells: [
        DataCell(Text('${player.name} ${player.surname ?? ''}', style: const TextStyle(color: Colors.white))),
        DataCell(Text(player.position ?? '', style: const TextStyle(color: Colors.white))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => onEdit(player),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => players.length;

  @override
  int get selectedRowCount => 0;
}
