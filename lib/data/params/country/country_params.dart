import 'package:json_annotation/json_annotation.dart';

part 'country_params.g.dart';

@JsonSerializable()
class CountryParams {

  CountryParams({required this.name, required this.nameShort});

  factory CountryParams.fromJson(Map<String, dynamic> json) =>
      _$CountryParamsFromJson(json);
  final String name;
  @JsonKey(name: 'short_name')
  final String nameShort;

  Map<String, dynamic> toJson() => _$CountryParamsToJson(this);
}
