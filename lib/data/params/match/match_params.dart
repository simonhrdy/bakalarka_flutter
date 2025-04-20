import 'package:json_annotation/json_annotation.dart';

part 'match_params.g.dart';

@JsonSerializable()
class MatchParams {
  @JsonKey(name: 'date_of_game')
  final String dateOfGame;

  final String? lap;

  final int status;

  @JsonKey(name: 'supervisor_id')
  final int? supervisorId;

  @JsonKey(name: 'home_team_id')
  final int homeTeamId;

  @JsonKey(name: 'away_team_id')
  final int awayTeamId;

  @JsonKey(name: 'league_id')
  final int leagueId;

  @JsonKey(name: 'player_action')
  final Map<String, dynamic> playerAction;

  @JsonKey(name: 'statistics')
  final Map<String, dynamic> statistics;

  @JsonKey(name: 'lineUpHome')
  final List<Map<String, dynamic>> lineUpHome;

  @JsonKey(name: 'lineUpAway')
  final List<Map<String, dynamic>> lineUpAway;

  final String? betting_tips;

  final String? match_analysis;

  MatchParams({
    required this.dateOfGame,
    this.lap,
    this.status = 0,
    this.supervisorId,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.leagueId,
    this.playerAction = const {},
    this.statistics = const {},
    this.lineUpAway = const [],
    this.lineUpHome = const [],
    this.betting_tips,
    this.match_analysis,
  });

  factory MatchParams.fromJson(Map<String, dynamic> json) => _$MatchParamsFromJson(json);

  Map<String, dynamic> toJson() => _$MatchParamsToJson(this);
}
