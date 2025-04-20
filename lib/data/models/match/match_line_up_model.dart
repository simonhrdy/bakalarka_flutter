class MatchLineUpModel {
  final int idPlayer;
  final int idTeam;
  final bool is_starter;
  final String? firstName;
  final String? lastName;

  MatchLineUpModel({
    required this.idTeam,
    required this.idPlayer,
    required this.is_starter,
    this.firstName,
    this.lastName,
  });

  factory MatchLineUpModel.fromJson(Map<String, dynamic> json) {
    return MatchLineUpModel(
      idPlayer: json['player']['id'] as int,
      idTeam: json['team']['id'] as int,
      is_starter: json['is_starter'] as bool,
      firstName: json['player']['first_name'] as String?,
      lastName: json['player']['last_name'] as String?,
    );
  }
}
