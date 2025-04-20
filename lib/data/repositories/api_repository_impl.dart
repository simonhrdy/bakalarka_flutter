import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:sportmatter/data/datasources/api_service.dart';
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
import 'package:sportmatter/data/resources/data_state.dart';
import 'package:sportmatter/domain/repositories/api_repository.dart';

class ApiRepositoryImpl implements ApiRepository {
  final ApiService _apiService;

  ApiRepositoryImpl(this._apiService);

  @override
  Future<DataState<LoginModel>> login(LoginParams params) async {
    try {
      final HttpResponse<LoginModel> httpResponse =
          await _apiService.login(params);

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == HttpStatus.created) {
        return DataSuccess(httpResponse.data);
      }
      return DataFailed(DioException(
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          error: httpResponse.response.statusMessage,
          type: DioExceptionType.unknown));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<UserModel>> getCurrentUser({String? token}) async {
    try {
      final bearer = token != null ? 'Bearer $token' : null;

      final HttpResponse<UserModel> httpResponse =
      await _apiService.getCurrentUser(bearer);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      }

      return DataFailed(DioException(
        response: httpResponse.response,
        requestOptions: httpResponse.response.requestOptions,
        error: httpResponse.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }


  @override
  Future<DataState<void>> createCountry(CountryParams params) async {
    try {
      final response = await _apiService.createCountry(params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.created) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<CountryModel>>> getCountries() async {
    try {
      final response = await _apiService.getCountries();

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(
        DioException(
          requestOptions: response.response.requestOptions,
          response: response.response,
          error: response.response.statusMessage,
          type: DioExceptionType.unknown,
        ),
      );
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteCountry(int id) async {
    try {
      final response = await _apiService.deleteCountry(id);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
  @override
  Future<DataState<CountryModel>> getCountryById(int id) async {
    try {
      final response = await _apiService.getCountryById(id);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateCountry(int id, CountryParams params) async {
    try {
      final response = await _apiService.updateCountry(id, params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> changePassword(int id, ChangePasswordParams params) async{
    try {
      final response = await _apiService.changePassword(id, params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> createTeam(TeamParams params) async {
    try {
      final response = await _apiService.createTeam(params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.created) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteTeam(int id) async {
    try {
      final response = await _apiService.deleteTeam(id);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<TeamModel>> getTeamById(int id) async {
    try {
      final response = await _apiService.getTeamById(id);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<TeamModel>>> getTeams() async {
    try {
      final response = await _apiService.getTeams();

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateTeam(int id, TeamParams params) async {
    try {
      final response = await _apiService.updateTeam(id, params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> createStadium(StadiumParams params) async {
    try {
      final response = await _apiService.createStadium(params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.created) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteStadium(int id) async {
    try {
      final response = await _apiService.deleteStadium(id);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<StadiumModel>> getStadiumById(int id) async {
    try {
      final response = await _apiService.getStadiumById(id);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<StadiumModel>>> getStadiums() async {
    try {
      final response = await _apiService.getStadiums();

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateStadium(int id, StadiumParams params) async {
    try {
      final response = await _apiService.updateStadium(id, params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> createPlayer(PlayerParams params) async {
    print('Params: $params');
    try {
      final response = await _apiService.createPlayer(params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.created) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }


  @override
  Future<DataState<void>> deletePlayer(int id) async {
    try {
      final response = await _apiService.deletePlayer(id);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<PlayerModel>> getPlayerById(int id) async {
    try {
      final response = await _apiService.getPlayerById(id);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<PlayerModel>>> getPlayers() async {
    try {
      final response = await _apiService.getPlayers();

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updatePlayer(int id, PlayerParams params) async {
    try {
      final response = await _apiService.updatePlayer(id, params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> createReferee(RefereeParams params) async {
    try {
      final response = await _apiService.createReferee(params);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.created) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteReferee(int id) async {
    try {
      final response = await _apiService.deleteReferee(id);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<RefereeModel>> getRefereeById(int id) async {
    try {
      final response = await _apiService.getRefereeById(id);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<RefereeModel>>> getReferees() async {
    try {
      final response = await _apiService.getReferees();
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateReferee(int id, RefereeParams params) async {
    try {
      final response = await _apiService.updateReferee(id, params);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> createUser(UserParams params) async {
    try {
      final response = await _apiService.createUser(params);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.created) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteUser(int id) async {
    try {
      final response = await _apiService.deleteUser(id);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<UserModel>> getUserById(int id) async {
    try {
      final response = await _apiService.getUserById(id);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<UserModel>>> getUsers() async {
    try {
      final response = await _apiService.getUsers();
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateUser(int id, UserParams params) async {
    try {
      final response = await _apiService.updateUser(id, params);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> createLeague(LeagueParams params) async {
    try {
      final response = await _apiService.createLeague(params);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.created) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteLeague(int id) async {
    try {
      final response = await _apiService.deleteLeague(id);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<LeagueModel>> getLeagueById(int id) async {
    try {
      final response = await _apiService.getLeagueById(id);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<LeagueModel>>> getLeagues() async {
    try {
      final response = await _apiService.getLeagues();
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateLeague(int id, LeagueParams params) async {
    try {
      final response = await _apiService.updateLeague(id, params);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
  @override
  Future<DataState<void>> createSeason(SeasonParams params) async {
    try {
      final response = await _apiService.createSeason(params);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.created) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteSeason(int id) async {
    try {
      final response = await _apiService.deleteSeason(id);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<SeasonModel>> getSeasonById(int id) async {
    try {
      final response = await _apiService.getSeasonById(id);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<SeasonModel>>> getSeasons() async {
    try {
      final response = await _apiService.getSeasons();
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateSeason(int id, SeasonParams params) async {
    try {
      final response = await _apiService.updateSeason(id, params);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<SportModel>> getSportById(int id) async {
    try {
      final response = await _apiService.getSportById(id);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<SportModel>>> getSports() async {
    try {
      final response = await _apiService.getSports();
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<MatchModel>>> getGamesBySuperVisor(int id, String date) async {
    try {
      final response = await _apiService.getGameBySuperVisor(id, date);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<MatchModel>>> getGames() async{
    try {
      final response = await _apiService.getGames();

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> forgotPassword(ForgotPasswordParams params) async {
    try {
      final response = await _apiService.forgotPassword(params);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<StadiumModel>>> getAvailableStadiums() async{
    try {
      final response = await _apiService.getAvailableStadiums();

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<SeasonModel>> getSeasonTeamsById(int id) async{

    try {
      final response = await _apiService.getSeasonTeamsById(id);
      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteSeasonTeam(int id, int idTeam) async{
    try {
      final response = await _apiService.deleteSeasonTeam(id, idTeam);
      if (response.response.statusCode == HttpStatus.ok || response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }
      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> addSeasonTeams(int seasonId, List<int> teamIds) async {
    try {
      final response = await _apiService.addSeasonTeams(
        seasonId,
        SeasonTeamsParams(teamIds: teamIds),
      );

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.created ||
          response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<TeamModel>>> getTeamsNotInSeason(int seasonId) async{
    try {
      final response = await _apiService.getTeamsNotInSeason(seasonId);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> createGame(MatchParams params) async{
    try {
      final response = await _apiService.createGame(params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.created) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<MatchModel>> getGameById(int id) async{
    try {
      final response = await _apiService.getGameById(id);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateGame(int id, MatchParams params) async{
    try {
      final response = await _apiService.updateGame(id, params);

      if (response.response.statusCode == HttpStatus.ok ||
          response.response.statusCode == HttpStatus.noContent) {
        return const DataSuccess(null);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<PlayerModel>>> getPlayersTeam(int idTeam) async{
    try {
      final response = await _apiService.getPlayersTeam(idTeam);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<MatchLineUpModel>>> getLineup(int gameId) async{
    try {
      final response = await _apiService.getLineup(gameId);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<MatchAnalysisModel>> getAnalysis(int gameId) async{
    try {
      final response = await _apiService.getAnalysis(gameId);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<MatchBettingModel>> getBetting(int gameId) async{
    try {
      final response = await _apiService.getBetting(gameId);

      if (response.response.statusCode == HttpStatus.ok) {
        return DataSuccess(response.data);
      }

      return DataFailed(DioException(
        response: response.response,
        requestOptions: response.response.requestOptions,
        error: response.response.statusMessage,
        type: DioExceptionType.unknown,
      ));
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

}
