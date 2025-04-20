import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
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
import 'package:sportmatter/data/params/season/season_teams_params.dart';
import 'package:sportmatter/data/params/stadium/stadium_params.dart';
import 'package:sportmatter/data/params/team/team_params.dart';
import 'package:sportmatter/data/params/user/user_params.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST('/api/login_check')
  Future<HttpResponse<LoginModel>> login(@Body() LoginParams body);

  @GET('/api/users/me')
  Future<HttpResponse<UserModel>> getCurrentUser(@Header("Authorization") String? authorization);

  @POST('/api/users/{id}/change-password')
  Future<HttpResponse<void>> changePassword(@Path('id') int id, @Body() ChangePasswordParams body);

  @POST('/api/users/forgot-password')
  Future<HttpResponse<void>> forgotPassword(@Body() ForgotPasswordParams body);

  @POST('/api/users')
  Future<HttpResponse<void>> createUser(@Body() UserParams body);

  @GET('/api/users')
  Future<HttpResponse<List<UserModel>>> getUsers();

  @DELETE('/api/users/{id}')
  Future<HttpResponse<void>> deleteUser(@Path('id') int id);

  @GET('/api/users/{id}')
  Future<HttpResponse<UserModel>> getUserById(@Path('id') int id);

  @PUT('/api/users/{id}')
  Future<HttpResponse<void>> updateUser(@Path('id') int id, @Body() UserParams body);


  //COUNTRIES
  @POST('/api/countries')
  Future<HttpResponse<void>> createCountry(@Body() CountryParams body);

  @GET('/api/countries')
  Future<HttpResponse<List<CountryModel>>> getCountries();

  @DELETE('/api/countries/{id}')
  Future<HttpResponse<void>> deleteCountry(@Path('id') int id);

  @GET('/api/countries/{id}')
  Future<HttpResponse<CountryModel>> getCountryById(@Path('id') int id);

  @PUT('/api/countries/{id}')
  Future<HttpResponse<void>> updateCountry(@Path('id') int id, @Body() CountryParams body);


  //TEAMS
  @POST('/api/teams')
  Future<HttpResponse<void>> createTeam(@Body() TeamParams body);

  @GET('/api/teams')
  Future<HttpResponse<List<TeamModel>>> getTeams();

  @GET('/api/teams/not-in-season/{seasonId}')
  Future<HttpResponse<List<TeamModel>>> getTeamsNotInSeason(@Path('seasonId') int seasonId);

  @DELETE('/api/teams/{id}')
  Future<HttpResponse<void>> deleteTeam(@Path('id') int id);

  @GET('/api/teams/{id}')
  Future<HttpResponse<TeamModel>> getTeamById(@Path('id') int id);

  @PUT('/api/teams/{id}')
  Future<HttpResponse<void>> updateTeam(@Path('id') int id, @Body() TeamParams body);


  //STADIIUMS
  @POST('/api/stadiums')
  Future<HttpResponse<void>> createStadium(@Body() StadiumParams body);

  @GET('/api/stadiums')
  Future<HttpResponse<List<StadiumModel>>> getStadiums();

  @GET('/api/stadiums/team/available')
  Future<HttpResponse<List<StadiumModel>>> getAvailableStadiums();

  @DELETE('/api/stadiums/{id}')
  Future<HttpResponse<void>> deleteStadium(@Path('id') int id);

  @GET('/api/stadiums/{id}')
  Future<HttpResponse<StadiumModel>> getStadiumById(@Path('id') int id);

  @PUT('/api/stadiums/{id}')
  Future<HttpResponse<void>> updateStadium(@Path('id') int id, @Body() StadiumParams body);


  //GAME
  @POST('/api/game')
  Future<HttpResponse<void>> createGame(@Body() MatchParams body);

  @GET('/api/game')
  Future<HttpResponse<List<MatchModel>>> getGames();

  @DELETE('/api/game/{id}')
  Future<HttpResponse<void>> deleteGame(@Path('id') int id);

  @GET('/api/game/{id}')
  Future<HttpResponse<MatchModel>> getGameById(@Path('id') int id);

  @PUT('/api/game/{id}')
  Future<HttpResponse<void>> updateGame(@Path('id') int id, @Body() MatchParams body);

  @GET('/api/game/viser/{id}/{date}')
  Future<HttpResponse<List<MatchModel>>> getGameBySuperVisor(
      @Path('id') int id,
      @Path('date') String date,
      );

  @GET('/api/game/{id}/getLineup')
  Future<HttpResponse<List<MatchLineUpModel>>> getLineup(@Path('id') int gameId);

  @GET('/api/game/{id}/getBetting')
  Future<HttpResponse<MatchBettingModel>> getBetting(@Path('id') int gameId);

  @GET('/api/game/{id}/getAnalysis')
  Future<HttpResponse<MatchAnalysisModel>> getAnalysis(@Path('id') int gameId);

  //REFEREE
  @POST('/api/referees')
  Future<HttpResponse<void>> createReferee(@Body() RefereeParams body);

  @GET('/api/referees')
  Future<HttpResponse<List<RefereeModel>>> getReferees();

  @DELETE('/api/referees/{id}')
  Future<HttpResponse<void>> deleteReferee(@Path('id') int id);

  @GET('/api/referees/{id}')
  Future<HttpResponse<RefereeModel>> getRefereeById(@Path('id') int id);

  @PUT('/api/referees/{id}')
  Future<HttpResponse<void>> updateReferee(@Path('id') int id, @Body() RefereeParams body);

  //SPORT
  @GET('/api/sports')
  Future<HttpResponse<List<SportModel>>> getSports();

  @GET('/api/sports/{id}')
  Future<HttpResponse<SportModel>> getSportById(@Path('id') int id);

// PLAYER
  @POST('/api/players')
  Future<HttpResponse<void>> createPlayer(@Body() PlayerParams body);

  @GET('/api/players')
  Future<HttpResponse<List<PlayerModel>>> getPlayers();

  @DELETE('/api/players/{id}')
  Future<HttpResponse<void>> deletePlayer(@Path('id') int id);

  @GET('/api/players/{id}')
  Future<HttpResponse<PlayerModel>> getPlayerById(@Path('id') int id);

  @GET('/api/players//team/{idTeam}')
  Future<HttpResponse<List<PlayerModel>>> getPlayersTeam(@Path('idTeam') int idTeam);

  @PUT('/api/players/{id}')
  Future<HttpResponse<void>> updatePlayer(@Path('id') int id, @Body() PlayerParams body);


  // LEAGUE
  @POST('/api/league')
  Future<HttpResponse<void>> createLeague(@Body() LeagueParams body);

  @GET('/api/league')
  Future<HttpResponse<List<LeagueModel>>> getLeagues();

  @DELETE('/api/league/{id}')
  Future<HttpResponse<void>> deleteLeague(@Path('id') int id);

  @GET('/api/league/{id}')
  Future<HttpResponse<LeagueModel>> getLeagueById(@Path('id') int id);

  @PUT('/api/league/{id}')
  Future<HttpResponse<void>> updateLeague(@Path('id') int id, @Body() LeagueParams body);


  //SEASON
  @POST('/api/seasons')
  Future<HttpResponse<void>> createSeason(@Body() SeasonParams body);

  @GET('/api/seasons')
  Future<HttpResponse<List<SeasonModel>>> getSeasons();

  @DELETE('/api/seasons/{id}')
  Future<HttpResponse<void>> deleteSeason(@Path('id') int id);

  @DELETE('/api/seasons/{id}/deleteTeam/{idTeam}')
  Future<HttpResponse<void>> deleteSeasonTeam(@Path('id') int id, @Path('idTeam') int idTeam);

  @GET('/api/seasons/{id}')
  Future<HttpResponse<SeasonModel>> getSeasonById(@Path('id') int id);

  @GET('/api/seasons/{id}')
  Future<HttpResponse<SeasonModel>> getSeasonTeamsById(@Path('id') int id);

  @PUT('/api/seasons/{id}')
  Future<HttpResponse<void>> updateSeason(@Path('id') int id, @Body() SeasonParams body);

  @POST('/api/seasons/{id}/addTeams')
  Future<HttpResponse<void>> addSeasonTeams(
      @Path("id") int seasonId,
      @Body() SeasonTeamsParams body,
      );

}
