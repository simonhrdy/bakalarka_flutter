import 'package:json_annotation/json_annotation.dart';

part 'league_params.g.dart';

@JsonSerializable()
class LeagueParams {
  final String name;

  final String? assocation;

  @JsonKey(name: 'image_src')
  final String? imageSrc;

  @JsonKey(name: 'country_id')
  final int? country;

  @JsonKey(name: 'sport_id')
  final int? sport;

  final String? imageBase64;

  LeagueParams({
    required this.name,
    this.assocation,
    this.imageSrc,
    this.country,
    this.sport,
    this.imageBase64
  });

  factory LeagueParams.fromJson(Map<String, dynamic> json) => _$LeagueParamsFromJson(json);
  Map<String, dynamic> toJson() => _$LeagueParamsToJson(this);
}
