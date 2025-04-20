import 'package:json_annotation/json_annotation.dart';

part 'team_params.g.dart';

@JsonSerializable()
class TeamParams {
  TeamParams({
    required this.name,
    this.surname,
    this.nameShort,
    this.coach,
    this.imageBase64,
    this.stadiumId,
  });

  factory TeamParams.fromJson(Map<String, dynamic> json) =>
      _$TeamParamsFromJson(json);

  final String name;

  final String? surname;

  @JsonKey(name: 'stadium_id')
  final int? stadiumId;

  @JsonKey(name: 'short_name')
  final String? nameShort;

  final String? coach;

  final String? imageBase64;

  Map<String, dynamic> toJson() => _$TeamParamsToJson(this);
}
