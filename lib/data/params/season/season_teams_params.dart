import 'package:json_annotation/json_annotation.dart';

part 'season_teams_params.g.dart';

@JsonSerializable()
class SeasonTeamsParams {
  final List<int> teamIds;

  SeasonTeamsParams({required this.teamIds});

  factory SeasonTeamsParams.fromJson(Map<String, dynamic> json) =>
      _$SeasonTeamsParamsFromJson(json);

  Map<String, dynamic> toJson() => _$SeasonTeamsParamsToJson(this);
}
