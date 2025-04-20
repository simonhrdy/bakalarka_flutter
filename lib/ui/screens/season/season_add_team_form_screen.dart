import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/data/models/team/team_model.dart';
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/hooks/repository/use_api_repository.dart';
import 'package:sportmatter/l10n/l10n.dart';
import 'package:sportmatter/layouts/main_layout.dart';
import 'package:sportmatter/widgets/button/button.dart';

@RoutePage()
class SeasonAddTeamFormScreen extends HookWidget {
  const SeasonAddTeamFormScreen({
    @PathParam('seasonId') required this.seasonId,
    super.key,
  });

  final int seasonId;

  @override
  Widget build(BuildContext context) {
    final repository = useApiRepository();
    final allTeams = useState<List<TeamModel>>([]);
    final selectedTeams = useState<List<TeamModel>>([]);
    final isSubmitting = useState(false);
    final error = useState<String?>(null);

    Future<void> loadTeams() async {
      final result = await repository.getTeamsNotInSeason(seasonId);
      if (result is DataSuccess && result.data != null) {
        allTeams.value = result.data!;
      } else {
        error.value = context.l10n.error;
      }
    }

    Future<void> submit() async {
      if (selectedTeams.value.isEmpty) return;

      isSubmitting.value = true;

      final teamIds = selectedTeams.value.map((t) => t.id).toList();
      final response = await repository.addSeasonTeams(
        seasonId,
        teamIds,
      );

      isSubmitting.value = false;

      if (response is DataSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.teamsAddedSuccess)),
        );
        await context.router.replace(SeasonAddTeamRoute(seasonId: seasonId));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.error)),
        );
      }
    }

    useEffect(() {
      loadTeams();
      return null;
    }, []);

    return MainScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.addTeamsToSeason,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              DropdownSearch<TeamModel>.multiSelection(
                items: allTeams.value,
                itemAsString: (team) => team.name,
                selectedItems: selectedTeams.value,
                onChanged: (items) => selectedTeams.value = items,
                popupProps: PopupPropsMultiSelection<TeamModel>.menu(
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected) => ListTile(
                    title: Text(item.name, style: const TextStyle(color: Colors.white)),
                    tileColor: isSelected ? Colors.grey[800] : Colors.black,
                  ),
                ),
                dropdownButtonProps: const DropdownButtonProps(
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: context.l10n.selectTeams,
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.black87,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                text: context.l10n.addTeamsToSeason,
                isDisabled: selectedTeams.value.isEmpty || isSubmitting.value,
                onPressed: submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
