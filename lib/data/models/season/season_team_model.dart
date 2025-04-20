class SeasonTeamModel {
  final int id;
  final String name;

  SeasonTeamModel({
    required this.id,
    required this.name,
  });

  factory SeasonTeamModel.fromJson(Map<String, dynamic> json) {
    final team = json['team_id'];
    return SeasonTeamModel(
      id: team['id'] as int,
      name: team['name'] as String,
    );
  }
}
