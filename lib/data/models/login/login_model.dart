import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  final String token;

  LoginModel({
    required this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);

  @override
  String toString() {
    return 'LoginModel{token: $token}';
  }
}


// @JsonSerializable()
// class LoginData {
//   final String token;
//   final String email;
//   final String username;
//   final String role;
//   final int id;

//   LoginData({
//     required this.token,
//     required this.email,
//     required this.username,
//     required this.role,
//     required this.id,
//   });

//   factory LoginData.fromJson(Map<String, dynamic> json) =>
//       _$LoginDataFromJson(json);

//   Map<String, dynamic> toJson() => _$LoginDataToJson(this);

//   @override
//   String toString() {
//     return 'LoginData{token: $token, email: $email, username: $username, role: $role, id: $id}';
//   }
// }
