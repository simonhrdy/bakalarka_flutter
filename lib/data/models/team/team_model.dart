import 'package:json_annotation/json_annotation.dart';
import '../country/country_model.dart';
import '../stadium/stadium_model.dart';

part 'team_model.g.dart';

@JsonSerializable()
class TeamModel {
  final int id;
  final String name;
  final String? surname;

  @JsonKey(name: 'short_name')
  final String? nameShort;

  final String? coach;

  @JsonKey(name: 'image_src')
  final String? imageSrc;

  final CountryModel? country;

  @JsonKey(name: 'stadium_id')
  final StadiumModel? stadium;

  TeamModel({
    required this.id,
    required this.name,
    this.surname,
    this.nameShort,
    this.coach,
    this.imageSrc,
    this.country,
    this.stadium,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) => _$TeamModelFromJson(json);
  Map<String, dynamic> toJson() => _$TeamModelToJson(this);
}
