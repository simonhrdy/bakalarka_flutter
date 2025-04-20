import 'package:auto_route/auto_route.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/user/user_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';

@RoutePage()
class UserScreen extends HookWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final users = useState<List<UserModel>>([]);
    final filteredUsers = useState<List<UserModel>>([]);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final searchController = useTextEditingController();
    final dataSource = useState<UserDataSource?>(null);

    late Future<void> Function() loadUsers;

    void filterUsers(String query) {
      final lower = query.toLowerCase();
      final filtered = users.value.where((user) {
        return user.name.toLowerCase().contains(lower) ||
            user.email.toLowerCase().contains(lower) ||
            user.roles.any((role) => role.toLowerCase().contains(lower));
      }).toList();

      filteredUsers.value = filtered;

      dataSource.value = UserDataSource(
        context: context,
        users: filtered,
        onEdit: (user) async {
          await context.router.push(UserFormRoute(userId: user.id));
          await loadUsers();
        },
        onDelete: (user) async {
        },
      );
    }

    loadUsers = () async {
      isLoading.value = true;
      error.value = null;

      final result = await repository.getUsers();

      if (result is DataSuccess && result.data != null) {
        users.value = result.data!;
        filteredUsers.value = result.data!;
        dataSource.value = UserDataSource(
          context: context,
          users: result.data!,
          onEdit: (user) async {
            await context.router.push(UserFormRoute(userId: user.id));
            await loadUsers();
          },
          onDelete: (user) async {
          },
        );
      } else {
        error.value = context.l10n.loadUsersError;;
      }

      isLoading.value = false;
    };

    useEffect(() {
      loadUsers();
      return null;
    }, []);

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.createUser,
              isDisabled: false,
              onPressed: () async {
                await context.router.push(UserFormRoute());
                await loadUsers();
              },
            ),
            const SizedBox(height: 30),
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: context.l10n.searchUserHint,
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
              onChanged: filterUsers,
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
                      bottomAppBarTheme: const BottomAppBarTheme(
                        color: Colors.black,
                      ),
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
                        DataColumn(label: Text(context.l10n.emailColumn, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(context.l10n.roleColumn, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
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

class UserDataSource extends DataTableSource {
  final List<UserModel> users;
  final BuildContext context;
  final void Function(UserModel user) onEdit;
  final void Function(UserModel user) onDelete;

  UserDataSource({
    required this.users,
    required this.context,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= users.length) return null;
    final user = users[index];

    return DataRow.byIndex(
      index: index,
      color: const WidgetStatePropertyAll(Colors.black),
      cells: [
        DataCell(Text(user.name, style: const TextStyle(color: Colors.white))),
        DataCell(Text(user.email, style: const TextStyle(color: Colors.white))),
        DataCell(Text(user.roles.join(', '), style: const TextStyle(color: Colors.white))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => onEdit(user),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
