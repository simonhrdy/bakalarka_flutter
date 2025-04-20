import 'package:auto_route/auto_route.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/league/league_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/widgets/button/button.dart';

@RoutePage()
class SelectLeagueScreen extends HookWidget {
  const SelectLeagueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final leagues = useState<List<LeagueModel>>([]);
    final selectedLeague = useState<LeagueModel?>(null);
    final isLoading = useState(true);

    useEffect(() {
      () async {
        final result = await repository.getLeagues();
        if (result is DataSuccess) {
          leagues.value = result.data!;
        }
        isLoading.value = false;
      }();
      return null;
    }, []);

    return MainScaffold(
      child: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.selectLeagueForMatch,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              DropdownSearch<LeagueModel>(
                items: leagues.value,
                selectedItem: selectedLeague.value,
                itemAsString: (league) => league.name,
                onChanged: (value) => selectedLeague.value = value,
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem?.name ?? context.l10n.selectLeague,
                  style: const TextStyle(color: Colors.white),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  menuProps: const MenuProps(
                    backgroundColor: Colors.black87,
                  ),
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: context.l10n.searchByLeague,
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  itemBuilder: (context, item, isSelected) => ListTile(
                    title: Text(item.name, style: const TextStyle(color: Colors.white)),
                    tileColor: isSelected ? Colors.grey[800] : Colors.black,
                  ),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: context.l10n.selectLeague,
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.black87,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                dropdownButtonProps: const DropdownButtonProps(
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: context.l10n.confirm,
                isDisabled: selectedLeague.value == null,
                onPressed: () {
                  if (selectedLeague.value != null) {
                    context.router.replace(
                      MatchFormRoute(id: selectedLeague.value!.id),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
