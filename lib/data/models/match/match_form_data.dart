import 'package:sportmatter/data/models/match/match_analysis_model.dart';
import 'package:sportmatter/data/models/match/match_betting_model.dart';
import 'package:sportmatter/data/models/match/match_model.dart';
import 'package:sportmatter/data/models/team/team_model.dart';
import 'package:sportmatter/data/models/user/user_model.dart';

class MatchFormData {
  final MatchModel match;
  final List<TeamModel> teams;
  final List<UserModel> users;
  final MatchBettingModel? betting;
  final MatchAnalysisModel? analysis;

  MatchFormData({
    required this.match,
    required this.teams,
    required this.users,
    this.betting,
    this.analysis,
  });
}
