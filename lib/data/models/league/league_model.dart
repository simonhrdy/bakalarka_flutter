import 'package:json_annotation/json_annotation.dart';
import 'package:sportmatter/data/models/country/country_model.dart';
import 'package:sportmatter/data/models/sport/sport_model.dart';

part 'league_model.g.dart';

@JsonSerializable()
class LeagueModel {
  final int id;
  final String name;
  final String? assocation;

  final SportModel? sport;

  @JsonKey(name: 'image_src')
  final String? imageSrc;

  @JsonKey(name: 'country_id')
  final CountryModel? country;


  LeagueModel({
    required this.id,
    required this.name,
    this.imageSrc,
    this.country,
    this.assocation,
    this.sport
  });

  factory LeagueModel.fromJson(Map<String, dynamic> json) => _$LeagueModelFromJson(json);
  Map<String, dynamic> toJson() => _$LeagueModelToJson(this);
}
