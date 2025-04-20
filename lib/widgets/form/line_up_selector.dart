import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sportmatter/data/models/player/player_model.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/widgets/responsive/responsive_row_column.dart';

class LineupSelector extends StatelessWidget {
  final String label;
  final List<PlayerModel> playersTeam1;
  final List<PlayerModel> playersTeam2;
  final ValueNotifier<List<PlayerModel>> selectedTeam1;
  final ValueNotifier<List<PlayerModel>> selectedTeam2;

  const LineupSelector({
    super.key,
    required this.label,
    required this.playersTeam1,
    required this.playersTeam2,
    required this.selectedTeam1,
    required this.selectedTeam2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ResponsiveRowOrColumn(
        spacing: 16,
        children: [
          _buildDropdown(
            context: context,
            label: '$label – ${context.l10n.homeTeam}',
            items: playersTeam1,
            selected: selectedTeam1.value,
            onChanged: (val) => selectedTeam1.value = val,
          ),
          _buildDropdown(
            context: context,
            label: '$label – ${context.l10n.awayTeam}',
            items: playersTeam2,
            selected: selectedTeam2.value,
            onChanged: (val) => selectedTeam2.value = val,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String label,
    required List<PlayerModel> items,
    required List<PlayerModel> selected,
    required void Function(List<PlayerModel>) onChanged,
  }) {
    return DropdownSearch<PlayerModel>.multiSelection(
      items: items,
      selectedItems: selected,
      itemAsString: (player) => '${player.name} ${player.surname ?? ''}',
      onChanged: (players) => onChanged(players),
      popupProps: const PopupPropsMultiSelection<PlayerModel>.menu(
        showSearchBox: true,
        menuProps: MenuProps(backgroundColor: Colors.black),
      ),
      dropdownButtonProps: const DropdownButtonProps(
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
