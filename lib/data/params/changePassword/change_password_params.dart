import 'package:json_annotation/json_annotation.dart';

part 'change_password_params.g.dart';

@JsonSerializable()
class ChangePasswordParams {

  ChangePasswordParams({required this.password});

  factory ChangePasswordParams.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordParamsFromJson(json);
  @JsonKey(name: 'new_password')
  final String password;

  Map<String, dynamic> toJson() => _$ChangePasswordParamsToJson(this);
}
