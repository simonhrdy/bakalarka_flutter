import 'package:json_annotation/json_annotation.dart';
import 'package:sportmatter/data/models/country/country_model.dart';
import 'package:sportmatter/data/models/team/team_model.dart';

part 'player_model.g.dart';

@JsonSerializable()
class PlayerModel {
  final int id;

  @JsonKey(name: 'first_name')
  final String name;

  @JsonKey(name: 'last_name')
  final String? surname;

  final DateTime? birthdate;

  final String? position;

  final int? number;

  @JsonKey(name: 'image_src')
  final String? imageSrc;

  final CountryModel? country;

  @JsonKey(name: 'team_id')
  final TeamModel? team;

  PlayerModel({
    required this.id,
    required this.name,
    this.surname,
    this.imageSrc,
    this.country,
    this.team,
    this.birthdate,
    this.position,
    this.number,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as int,
      name: json['first_name'] as String,
      surname: json['last_name'] as String?,
      birthdate: json['birthdate'] is String
          ? DateTime.tryParse(json['birthdate'] as String)
          : null,
      position: json['position'] as String?,
      number: json['number'] is int
          ? json['number'] as int
          : int.tryParse(json['number']?.toString() ?? ''),
      imageSrc: json['image_src'] as String?,
      country: json['country'] is Map<String, dynamic>
          ? CountryModel.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      team: json['team_id'] is Map<String, dynamic>
          ? TeamModel.fromJson(json['team_id'] as Map<String, dynamic>)
          : null,
    );
  }


  Map<String, dynamic> toJson() => _$PlayerModelToJson(this);
}
