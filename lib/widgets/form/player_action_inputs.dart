import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sportmatter/data/models/player/player_model.dart';
import 'package:sportmatter/data/params/player/player_action_params.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/widgets/responsive/responsive_row_column.dart';
import 'package:collection/collection.dart';

class PlayerActionInputs extends StatelessWidget {
  final ValueNotifier<List<PlayerAction>> actionsList;
  final List<PlayerModel> playerList;
  final List<DropdownMenuItem<int>> actionTypeItems;
  final String team;

  const PlayerActionInputs({
    super.key,
    required this.actionsList,
    required this.playerList,
    required this.actionTypeItems,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...actionsList.value.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ResponsiveRowOrColumn(
              spacing: 8,
              children: [
                SizedBox(
                  width: isWide ? 300 : double.infinity,
                  child: DropdownSearch<PlayerModel>(
                    items: playerList,
                    selectedItem: playerList.firstWhereOrNull((p) => p.id == action.playerId),
                    itemAsString: (p) => '${p.name} ${p.surname ?? ''}',
                    onChanged: (p) {
                      action.playerId = p?.id;
                      action.playerName = p != null ? '${p.name} ${p.surname ?? ''}'.trim() : null;
                      actionsList.value = [...actionsList.value];
                    },
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                      menuProps: MenuProps(backgroundColor: Colors.black),
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: context.l10n.actionPlayer,
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.black,
                        border: const OutlineInputBorder(),
                      ),
                      baseStyle: const TextStyle(color: Colors.white),
                    ),
                    dropdownButtonProps: const DropdownButtonProps(
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white)),
                  ),
                ),
                SizedBox(
                  width: isWide ? 200 : double.infinity,
                  child: DropdownButtonFormField<int>(
                    value: action.type,
                    items: actionTypeItems,
                    onChanged: (val) {
                      action.type = val;
                      actionsList.value = [...actionsList.value];
                    },
                    decoration: InputDecoration(
                      labelText: context.l10n.actionType,
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black,
                      border: const OutlineInputBorder(),
                    ),
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: isWide ? 80 : double.infinity,
                  child: TextFormField(
                    initialValue: action.minute?.toString(),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: context.l10n.minuteShort,
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      action.minute = int.tryParse(val);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    actionsList.value = [...actionsList.value..removeAt(index)];
                  },
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: () {
            actionsList.value = [...actionsList.value, PlayerAction()];
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            context.l10n.addActionButton,
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
