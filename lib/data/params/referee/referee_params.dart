import 'package:json_annotation/json_annotation.dart';

part 'referee_params.g.dart';

@JsonSerializable()
class RefereeParams {
  RefereeParams({
    required this.name,
    required this.surname,
  });

  factory RefereeParams.fromJson(Map<String, dynamic> json) =>
      _$RefereeParamsFromJson(json);

  @JsonKey(name: 'first_name')
  final String name;

  @JsonKey(name: 'last_name')
  final String surname;

  Map<String, dynamic> toJson() => _$RefereeParamsToJson(this);
}
