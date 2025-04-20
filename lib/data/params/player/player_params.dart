import 'package:json_annotation/json_annotation.dart';

part 'player_params.g.dart';

@JsonSerializable()
class PlayerParams {
  @JsonKey(name: 'first_name')
  final String name;

  @JsonKey(name: 'last_name')
  final String? surname;

  final DateTime? birthdate;

  final String? position;

  final int? number;

  final String? imageBase64;

  final int? country;

  @JsonKey(name: 'team_id')
  final int? team;

  PlayerParams({
    required this.name,
    this.surname,
    this.birthdate,
    this.position,
    this.number,
    this.imageBase64,
    this.country,
    this.team,
  });

  factory PlayerParams.fromJson(Map<String, dynamic> json) => _$PlayerParamsFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerParamsToJson(this);
}

