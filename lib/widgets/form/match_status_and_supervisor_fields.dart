import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sportmatter/data/models/user/user_model.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/widgets/responsive/responsive_row_column.dart';

class MatchStatusAndSupervisorFields extends StatelessWidget {
  const MatchStatusAndSupervisorFields({
    super.key,
    required this.status,
    required this.supervisor,
    required this.users,
  });

  final ValueNotifier<int> status;
  final ValueNotifier<UserModel?> supervisor;
  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    return ResponsiveRowOrColumn(
      children: [
        DropdownSearch<int>(
          items: const [0, 1],
          selectedItem: status.value,
          itemAsString: (status) =>
          status == 0 ? context.l10n.statusNotStarted : context.l10n.statusFinished,
          onChanged: (val) => status.value = val ?? 0,
          popupProps: const PopupProps.menu(
            showSearchBox: false,
            menuProps: MenuProps(backgroundColor: Colors.black),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: context.l10n.status,
              labelStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black,
              border: const OutlineInputBorder(),
            ),
          ),
          dropdownBuilder: (context, item) => Text(
            item == 0 ? context.l10n.statusNotStarted : context.l10n.statusFinished,
            style: const TextStyle(color: Colors.white),
          ),
          dropdownButtonProps: const DropdownButtonProps(
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          ),
        ),
        DropdownSearch<UserModel>(
          items: users,
          selectedItem: supervisor.value,
          itemAsString: (u) => u.email,
          onChanged: (val) => supervisor.value = val,
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            menuProps: MenuProps(backgroundColor: Colors.black),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: context.l10n.supervisor,
              labelStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black,
              border: const OutlineInputBorder(),
            ),
          ),
          dropdownBuilder: (context, item) => Text(
            item?.email ?? '',
            style: const TextStyle(color: Colors.white),
          ),
          dropdownButtonProps: const DropdownButtonProps(
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
