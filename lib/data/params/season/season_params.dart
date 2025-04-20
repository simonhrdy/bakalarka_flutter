import 'package:json_annotation/json_annotation.dart';

part 'season_params.g.dart';

@JsonSerializable()
class SeasonParams {
  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'year_start')
  final DateTime yearStart;

  @JsonKey(name: 'year_end')
  final DateTime yearEnd;

  @JsonKey(name: 'league_id')
  final int leagueId;

  SeasonParams({
    required this.isActive,
    required this.yearStart,
    required this.yearEnd,
    required this.leagueId,
  });

  factory SeasonParams.fromJson(Map<String, dynamic> json) => _$SeasonParamsFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonParamsToJson(this);
}
