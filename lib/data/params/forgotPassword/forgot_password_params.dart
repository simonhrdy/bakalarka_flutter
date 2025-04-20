import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_params.g.dart';

@JsonSerializable()
class ForgotPasswordParams{

  ForgotPasswordParams({required this.email});

  factory ForgotPasswordParams.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordParamsFromJson(json);
  final String email;

  Map<String, dynamic> toJson() => _$ForgotPasswordParamsToJson(this);
}
