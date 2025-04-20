import 'package:json_annotation/json_annotation.dart';

part 'referee_model.g.dart';

@JsonSerializable()
class RefereeModel {
  final int id;
  @JsonKey(name: 'first_name')
  final String name;

  @JsonKey(name: 'last_name')
  final String surname;

  RefereeModel({
    required this.id,
    required this.name,
    required this.surname,
  });

  factory RefereeModel.fromJson(Map<String, dynamic> json) =>
      _$RefereeModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefereeModelToJson(this);
}
