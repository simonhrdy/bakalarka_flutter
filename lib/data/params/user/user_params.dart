import 'package:json_annotation/json_annotation.dart';

part 'user_params.g.dart';

@JsonSerializable()
class UserParams {
  final String name;
  final String email;
  final String? password;

  final List<String> roles;

  UserParams({
    required this.name,
    required this.email,
    required this.roles,
    this.password
  });

  factory UserParams.fromJson(Map<String, dynamic> json) => _$UserParamsFromJson(json);
  Map<String, dynamic> toJson() => _$UserParamsToJson(this);
}
