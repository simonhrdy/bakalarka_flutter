import 'package:sportmatter/data/models/season/season_team_model.dart';

class SeasonModel {
  final int id;
  final bool isActive;
  final DateTime? yearStart;
  final DateTime? yearEnd;
  final int? leagueId;
  final String? leagueName;
  final List<SeasonTeamModel>? seasonHasTeams;

  SeasonModel({
    required this.id,
    required this.isActive,
    this.yearStart,
    this.yearEnd,
    this.leagueId,
    this.leagueName,
    this.seasonHasTeams,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: json['id'] as int,
      isActive: json['is_active'] as bool,
      yearStart: json['yearStart'] != null ? DateTime.parse(json['yearStart'] as String) : null,
      yearEnd: json['yearEnd'] != null ? DateTime.parse(json['yearEnd'] as String) : null,
      leagueId: json['league_id']['id'] as int,
      leagueName: json['league_id']['name'] as String?,
      seasonHasTeams: (json['seasonHasTeams'] as List<dynamic>?)
          ?.map((e) => SeasonTeamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'is_active': isActive,
    'yearStart': yearStart?.toIso8601String(),
    'yearEnd': yearEnd?.toIso8601String(),
    'league_id': leagueId,
    'league_name': leagueName,
  };
}
