import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.userIdentifier,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  final int id;
  final String name;
  final String email;
  @JsonKey(defaultValue: [])
  final List<String> roles;

  @JsonKey(name: 'userIdentifier', defaultValue: '')
  final String userIdentifier;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
