import 'package:sportmatter/data/models/country/country_model.dart';
import 'package:sportmatter/data/models/league/league_model.dart';
import 'package:sportmatter/data/models/login/login_model.dart';
import 'package:sportmatter/data/models/match/match_analysis_model.dart';
import 'package:sportmatter/data/models/match/match_betting_model.dart';
import 'package:sportmatter/data/models/match/match_line_up_model.dart';
import 'package:sportmatter/data/models/match/match_model.dart';
import 'package:sportmatter/data/models/player/player_model.dart';
import 'package:sportmatter/data/models/referee/referee_model.dart';
import 'package:sportmatter/data/models/season/season_model.dart';
import 'package:sportmatter/data/models/sport/sport_model.dart';
import 'package:sportmatter/data/models/stadium/stadium_model.dart';
import 'package:sportmatter/data/models/team/team_model.dart';
import 'package:sportmatter/data/models/user/user_model.dart';
import 'package:sportmatter/data/params/changePassword/change_password_params.dart';
import 'package:sportmatter/data/params/country/country_params.dart';
import 'package:sportmatter/data/params/forgotPassword/forgot_password_params.dart';
import 'package:sportmatter/data/params/league/league_params.dart';
import 'package:sportmatter/data/params/login/login_params.dart';
import 'package:sportmatter/data/params/match/match_params.dart';
import 'package:sportmatter/data/params/player/player_params.dart';
import 'package:sportmatter/data/params/referee/referee_params.dart';
import 'package:sportmatter/data/params/season/season_params.dart';
import 'package:sportmatter/data/params/stadium/stadium_params.dart';
import 'package:sportmatter/data/params/team/team_params.dart';
import 'package:sportmatter/data/params/user/user_params.dart';
import 'package:sportmatter/data/resources/data_state.dart';

abstract class ApiRepository {
  Future<DataState<LoginModel>> login(LoginParams params);
  Future<DataState<UserModel>> getCurrentUser({String? token});
  Future<DataState<void>> changePassword(int id, ChangePasswordParams params);
  Future<DataState<void>> forgotPassword(ForgotPasswordParams params);
  Future<DataState<void>> createUser(UserParams params);
  Future<DataState<List<UserModel>>> getUsers();
  Future<DataState<void>> deleteUser(int id);
  Future<DataState<UserModel>> getUserById(int id);
  Future<DataState<void>> updateUser(int id, UserParams params);


  Future<DataState<void>> createCountry(CountryParams params);
  Future<DataState<List<CountryModel>>> getCountries();
  Future<DataState<void>> deleteCountry(int id);
  Future<DataState<CountryModel>> getCountryById(int id);
  Future<DataState<void>> updateCountry(int id, CountryParams params);


  Future<DataState<void>> createTeam(TeamParams params);
  Future<DataState<List<TeamModel>>> getTeams();
  Future<DataState<List<TeamModel>>> getTeamsNotInSeason(int seasonId);
  Future<DataState<void>> deleteTeam(int id);
  Future<DataState<TeamModel>> getTeamById(int id);
  Future<DataState<void>> updateTeam(int id, TeamParams params);


  Future<DataState<void>> createStadium(StadiumParams params);
  Future<DataState<List<StadiumModel>>> getStadiums();
  Future<DataState<List<StadiumModel>>> getAvailableStadiums();
  Future<DataState<void>> deleteStadium(int id);
  Future<DataState<StadiumModel>> getStadiumById(int id);
  Future<DataState<void>> updateStadium(int id, StadiumParams params);

  //TODO GAME
  Future<DataState<List<MatchModel>>> getGamesBySuperVisor(int id, String date);
  Future<DataState<List<MatchModel>>> getGames();
  Future<DataState<MatchModel>> getGameById(int id);
  Future<DataState<void>> createGame(MatchParams params);
  Future<DataState<void>> updateGame(int id, MatchParams params);

  Future<DataState<void>> createReferee(RefereeParams params);
  Future<DataState<List<RefereeModel>>> getReferees();
  Future<DataState<void>> deleteReferee(int id);
  Future<DataState<RefereeModel>> getRefereeById(int id);
  Future<DataState<void>> updateReferee(int id, RefereeParams params);


  Future<DataState<List<SportModel>>> getSports();
  Future<DataState<SportModel>> getSportById(int id);


  Future<DataState<void>> createPlayer(PlayerParams params);
  Future<DataState<List<PlayerModel>>> getPlayers();
  Future<DataState<void>> deletePlayer(int id);
  Future<DataState<PlayerModel>> getPlayerById(int id);
  Future<DataState<void>> updatePlayer(int id, PlayerParams params);
  Future<DataState<List<PlayerModel>>> getPlayersTeam(int idTeam);
  Future<DataState<List<MatchLineUpModel>>> getLineup(int gameId);
  Future<DataState<MatchBettingModel>> getBetting(int gameId);
  Future<DataState<MatchAnalysisModel>> getAnalysis(int gameId);


  Future<DataState<void>> createLeague(LeagueParams params);
  Future<DataState<List<LeagueModel>>> getLeagues();
  Future<DataState<void>> deleteLeague(int id);
  Future<DataState<LeagueModel>> getLeagueById(int id);
  Future<DataState<void>> updateLeague(int id, LeagueParams params);

  Future<DataState<void>> createSeason(SeasonParams params);
  Future<DataState<void>> addSeasonTeams(int seasonId, List<int> teamIds);
  Future<DataState<List<SeasonModel>>> getSeasons();
  Future<DataState<void>> deleteSeason(int id);
  Future<DataState<void>> deleteSeasonTeam(int id, int idTeam);
  Future<DataState<SeasonModel>> getSeasonById(int id);
  Future<DataState<SeasonModel>> getSeasonTeamsById(int id);
  Future<DataState<void>> updateSeason(int id, SeasonParams params);
}
