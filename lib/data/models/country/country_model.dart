import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel {
  final int? id;
  final String? name;

  @JsonKey(name: 'short_name')
  final String? nameShort;

  CountryModel({
    required this.id,
    required this.name,
    required this.nameShort,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      nameShort: json['shortName'] as String? ?? json['short_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$CountryModelToJson(this);
}
