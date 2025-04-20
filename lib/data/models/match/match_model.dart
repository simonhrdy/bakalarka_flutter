import 'package:intl/intl.dart';

class MatchModel {
  final int id;
  final DateTime? date;
  final int homeTeamId;
  final String? homeTeamName;
  final String? homeTeamImage;
  final int awayTeamId;
  final String? awayTeamName;
  final String? awayTeamImage;
  final int leagueId;
  final String? leagueName;
  final int? lap;
  final int? status;
  final int? supervisor;
  final String? sport;
  final Map<String, dynamic>? parametrs;

  MatchModel({
    required this.id,
    required this.date,
    required this.homeTeamId,
    this.homeTeamName,
    this.homeTeamImage,
    required this.awayTeamId,
    this.awayTeamName,
    this.awayTeamImage,
    required this.leagueId,
    this.leagueName,
    this.lap,
    this.status,
    this.supervisor,
    this.sport,
    this.parametrs,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] as int,
      date: json['date_of_game'] != null
          ? DateTime.parse(json['date_of_game'] as String)
          : null,
      homeTeamId: json['home_team_id']['id'] as int,
      homeTeamName: json['home_team_id']['name'] as String?,
      homeTeamImage: json['home_team_id']['image_src'] as String?,
      awayTeamId: json['away_team_id']['id'] as int,
      awayTeamName: json['away_team_id']['name'] as String?,
      awayTeamImage: json['away_team_id']['image_src'] as String?,
      leagueId: json['league_id']['id'] as int,
      leagueName: json['league_id']['name'] as String?,
      lap: json['lap'] as int?,
      status: json['status'] as int?,
      supervisor: json['superviser_id']['id'] as int?,
      sport: json['league_id']['sport']['url'] as String?,
      parametrs: json['parametrs'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date?.toIso8601String(),
    'home_team_id': homeTeamId,
    'home_team_name': homeTeamName,
    'home_team_image': homeTeamImage,
    'away_team_id': awayTeamId,
    'away_team_name': awayTeamName,
    'away_team_image': awayTeamImage,
    'league_id': leagueId,
    'league_name': leagueName,
    'lap': lap,
    'status': status,
    'supervisor': supervisor,
    'sport': sport,
    'parametrs': parametrs,
  };

  String get statusLabel {
    if (status == 0) {
      return 'Nezahájeno';
    } else if (status == 1) {
      return 'Dohráno';
    } else {
      return 'Neznámý stav';
    }
  }

  String get formattedDateCz {
    if (date == null) return '';
    final formatter = DateFormat('d. M. y HH:mm', 'cs_CZ');
    return formatter.format(date!.toLocal());
  }
}
