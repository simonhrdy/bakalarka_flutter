// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i30;
import 'package:flutter/foundation.dart' as _i32;
import 'package:flutter/material.dart' as _i31;
import 'package:sportmatter/ui/screens/change_password/change_password_screen.dart'
    as _i16;
import 'package:sportmatter/ui/screens/country/country_form_screen.dart' as _i1;
import 'package:sportmatter/ui/screens/country/country_screen.dart' as _i2;
import 'package:sportmatter/ui/screens/forgot_password/forgot_password_screen.dart'
    as _i3;
import 'package:sportmatter/ui/screens/home/home_screen.dart' as _i4;
import 'package:sportmatter/ui/screens/league/league_form_screen.dart' as _i5;
import 'package:sportmatter/ui/screens/league/league_screen.dart' as _i6;
import 'package:sportmatter/ui/screens/login/login_screen.dart' as _i7;
import 'package:sportmatter/ui/screens/match/match_form_screen.dart' as _i8;
import 'package:sportmatter/ui/screens/match/match_league_select_form_screen.dart'
    as _i21;
import 'package:sportmatter/ui/screens/match/match_management_screen.dart'
    as _i9;
import 'package:sportmatter/ui/screens/match/match_screen.dart' as _i10;
import 'package:sportmatter/ui/screens/player/player_form_screen.dart' as _i11;
import 'package:sportmatter/ui/screens/player/player_screen.dart' as _i12;
import 'package:sportmatter/ui/screens/profile/profile_screen.dart' as _i13;
import 'package:sportmatter/ui/screens/referee/referee_form_screen.dart'
    as _i14;
import 'package:sportmatter/ui/screens/referee/referee_screen.dart' as _i15;
import 'package:sportmatter/ui/screens/season/season_add_team_form_screen.dart'
    as _i17;
import 'package:sportmatter/ui/screens/season/season_add_team_screen.dart'
    as _i18;
import 'package:sportmatter/ui/screens/season/season_form_screen.dart' as _i19;
import 'package:sportmatter/ui/screens/season/season_screen.dart' as _i20;
import 'package:sportmatter/ui/screens/settings/settings_screen.dart' as _i22;
import 'package:sportmatter/ui/screens/splash/splash_screen.dart' as _i23;
import 'package:sportmatter/ui/screens/stadium/stadium_form_screen.dart'
    as _i24;
import 'package:sportmatter/ui/screens/stadium/stadium_screen.dart' as _i25;
import 'package:sportmatter/ui/screens/team/team_form_screen.dart' as _i26;
import 'package:sportmatter/ui/screens/team/team_screen.dart' as _i27;
import 'package:sportmatter/ui/screens/user/user_form_screen.dart' as _i28;
import 'package:sportmatter/ui/screens/user/user_screen.dart' as _i29;

/// generated route for
/// [_i1.CountryFormScreen]
class CountryFormRoute extends _i30.PageRouteInfo<CountryFormRouteArgs> {
  CountryFormRoute({
    int? countryId,
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          CountryFormRoute.name,
          args: CountryFormRouteArgs(
            countryId: countryId,
            key: key,
          ),
          rawPathParams: {'countryId': countryId},
          initialChildren: children,
        );

  static const String name = 'CountryFormRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CountryFormRouteArgs>(
          orElse: () =>
              CountryFormRouteArgs(countryId: pathParams.optInt('countryId')));
      return _i1.CountryFormScreen(
        countryId: args.countryId,
        key: args.key,
      );
    },
  );
}

class CountryFormRouteArgs {
  const CountryFormRouteArgs({
    this.countryId,
    this.key,
  });

  final int? countryId;

  final _i31.Key? key;

  @override
  String toString() {
    return 'CountryFormRouteArgs{countryId: $countryId, key: $key}';
  }
}

/// generated route for
/// [_i2.CountryScreen]
class CountryRoute extends _i30.PageRouteInfo<void> {
  const CountryRoute({List<_i30.PageRouteInfo>? children})
      : super(
          CountryRoute.name,
          initialChildren: children,
        );

  static const String name = 'CountryRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i2.CountryScreen();
    },
  );
}

/// generated route for
/// [_i3.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i30.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i30.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i3.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i4.HomeScreen]
class HomeRoute extends _i30.PageRouteInfo<void> {
  const HomeRoute({List<_i30.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i4.HomeScreen();
    },
  );
}

/// generated route for
/// [_i5.LeagueFormScreen]
class LeagueFormRoute extends _i30.PageRouteInfo<LeagueFormRouteArgs> {
  LeagueFormRoute({
    int? leagueId,
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          LeagueFormRoute.name,
          args: LeagueFormRouteArgs(
            leagueId: leagueId,
            key: key,
          ),
          rawPathParams: {'leagueId': leagueId},
          initialChildren: children,
        );

  static const String name = 'LeagueFormRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<LeagueFormRouteArgs>(
          orElse: () =>
              LeagueFormRouteArgs(leagueId: pathParams.optInt('leagueId')));
      return _i5.LeagueFormScreen(
        leagueId: args.leagueId,
        key: args.key,
      );
    },
  );
}

class LeagueFormRouteArgs {
  const LeagueFormRouteArgs({
    this.leagueId,
    this.key,
  });

  final int? leagueId;

  final _i31.Key? key;

  @override
  String toString() {
    return 'LeagueFormRouteArgs{leagueId: $leagueId, key: $key}';
  }
}

/// generated route for
/// [_i6.LeagueScreen]
class LeagueRoute extends _i30.PageRouteInfo<void> {
  const LeagueRoute({List<_i30.PageRouteInfo>? children})
      : super(
          LeagueRoute.name,
          initialChildren: children,
        );

  static const String name = 'LeagueRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i6.LeagueScreen();
    },
  );
}

/// generated route for
/// [_i7.LoginScreen]
class LoginRoute extends _i30.PageRouteInfo<void> {
  const LoginRoute({List<_i30.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i7.LoginScreen();
    },
  );
}

/// generated route for
/// [_i8.MatchFormScreen]
class MatchFormRoute extends _i30.PageRouteInfo<MatchFormRouteArgs> {
  MatchFormRoute({
    int? id,
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          MatchFormRoute.name,
          args: MatchFormRouteArgs(
            id: id,
            key: key,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'MatchFormRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MatchFormRouteArgs>(
          orElse: () => MatchFormRouteArgs(id: pathParams.optInt('id')));
      return _i8.MatchFormScreen(
        id: args.id,
        key: args.key,
      );
    },
  );
}

class MatchFormRouteArgs {
  const MatchFormRouteArgs({
    this.id,
    this.key,
  });

  final int? id;

  final _i31.Key? key;

  @override
  String toString() {
    return 'MatchFormRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i9.MatchManagementScreen]
class MatchManagementRoute
    extends _i30.PageRouteInfo<MatchManagementRouteArgs> {
  MatchManagementRoute({
    required int matchId,
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          MatchManagementRoute.name,
          args: MatchManagementRouteArgs(
            matchId: matchId,
            key: key,
          ),
          rawPathParams: {'matchId': matchId},
          initialChildren: children,
        );

  static const String name = 'MatchManagementRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MatchManagementRouteArgs>(
          orElse: () =>
              MatchManagementRouteArgs(matchId: pathParams.getInt('matchId')));
      return _i9.MatchManagementScreen(
        matchId: args.matchId,
        key: args.key,
      );
    },
  );
}

class MatchManagementRouteArgs {
  const MatchManagementRouteArgs({
    required this.matchId,
    this.key,
  });

  final int matchId;

  final _i31.Key? key;

  @override
  String toString() {
    return 'MatchManagementRouteArgs{matchId: $matchId, key: $key}';
  }
}

/// generated route for
/// [_i10.MatchScreen]
class MatchRoute extends _i30.PageRouteInfo<void> {
  const MatchRoute({List<_i30.PageRouteInfo>? children})
      : super(
          MatchRoute.name,
          initialChildren: children,
        );

  static const String name = 'MatchRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i10.MatchScreen();
    },
  );
}

/// generated route for
/// [_i11.PlayerFormScreen]
class PlayerFormRoute extends _i30.PageRouteInfo<PlayerFormRouteArgs> {
  PlayerFormRoute({
    int? playerId,
    _i32.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          PlayerFormRoute.name,
          args: PlayerFormRouteArgs(
            playerId: playerId,
            key: key,
          ),
          rawPathParams: {'playerId': playerId},
          initialChildren: children,
        );

  static const String name = 'PlayerFormRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PlayerFormRouteArgs>(
          orElse: () =>
              PlayerFormRouteArgs(playerId: pathParams.optInt('playerId')));
      return _i11.PlayerFormScreen(
        playerId: args.playerId,
        key: args.key,
      );
    },
  );
}

class PlayerFormRouteArgs {
  const PlayerFormRouteArgs({
    this.playerId,
    this.key,
  });

  final int? playerId;

  final _i32.Key? key;

  @override
  String toString() {
    return 'PlayerFormRouteArgs{playerId: $playerId, key: $key}';
  }
}

/// generated route for
/// [_i12.PlayerScreen]
class PlayerRoute extends _i30.PageRouteInfo<void> {
  const PlayerRoute({List<_i30.PageRouteInfo>? children})
      : super(
          PlayerRoute.name,
          initialChildren: children,
        );

  static const String name = 'PlayerRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i12.PlayerScreen();
    },
  );
}

/// generated route for
/// [_i13.ProfileScreen]
class ProfileRoute extends _i30.PageRouteInfo<void> {
  const ProfileRoute({List<_i30.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i13.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i14.RefereeFormScreen]
class RefereeFormRoute extends _i30.PageRouteInfo<RefereeFormRouteArgs> {
  RefereeFormRoute({
    int? refereeId,
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          RefereeFormRoute.name,
          args: RefereeFormRouteArgs(
            refereeId: refereeId,
            key: key,
          ),
          rawPathParams: {'refereeId': refereeId},
          initialChildren: children,
        );

  static const String name = 'RefereeFormRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<RefereeFormRouteArgs>(
          orElse: () =>
              RefereeFormRouteArgs(refereeId: pathParams.optInt('refereeId')));
      return _i14.RefereeFormScreen(
        refereeId: args.refereeId,
        key: args.key,
      );
    },
  );
}

class RefereeFormRouteArgs {
  const RefereeFormRouteArgs({
    this.refereeId,
    this.key,
  });

  final int? refereeId;

  final _i31.Key? key;

  @override
  String toString() {
    return 'RefereeFormRouteArgs{refereeId: $refereeId, key: $key}';
  }
}

/// generated route for
/// [_i15.RefereeScreen]
class RefereeRoute extends _i30.PageRouteInfo<void> {
  const RefereeRoute({List<_i30.PageRouteInfo>? children})
      : super(
          RefereeRoute.name,
          initialChildren: children,
        );

  static const String name = 'RefereeRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i15.RefereeScreen();
    },
  );
}

/// generated route for
/// [_i16.ResetPasswordScreen]
class ResetPasswordRoute extends _i30.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i30.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i16.ResetPasswordScreen();
    },
  );
}

/// generated route for
/// [_i17.SeasonAddTeamFormScreen]
class SeasonAddTeamFormRoute
    extends _i30.PageRouteInfo<SeasonAddTeamFormRouteArgs> {
  SeasonAddTeamFormRoute({
    required int seasonId,
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          SeasonAddTeamFormRoute.name,
          args: SeasonAddTeamFormRouteArgs(
            seasonId: seasonId,
            key: key,
          ),
          rawPathParams: {'seasonId': seasonId},
          initialChildren: children,
        );

  static const String name = 'SeasonAddTeamFormRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SeasonAddTeamFormRouteArgs>(
          orElse: () => SeasonAddTeamFormRouteArgs(
              seasonId: pathParams.getInt('seasonId')));
      return _i17.SeasonAddTeamFormScreen(
        seasonId: args.seasonId,
        key: args.key,
      );
    },
  );
}

class SeasonAddTeamFormRouteArgs {
  const SeasonAddTeamFormRouteArgs({
    required this.seasonId,
    this.key,
  });

  final int seasonId;

  final _i31.Key? key;

  @override
  String toString() {
    return 'SeasonAddTeamFormRouteArgs{seasonId: $seasonId, key: $key}';
  }
}

/// generated route for
/// [_i18.SeasonAddTeamScreen]
class SeasonAddTeamRoute extends _i30.PageRouteInfo<SeasonAddTeamRouteArgs> {
  SeasonAddTeamRoute({
    int? seasonId,
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          SeasonAddTeamRoute.name,
          args: SeasonAddTeamRouteArgs(
            seasonId: seasonId,
            key: key,
          ),
          rawPathParams: {'seasonId': seasonId},
          initialChildren: children,
        );

  static const String name = 'SeasonAddTeamRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SeasonAddTeamRouteArgs>(
          orElse: () =>
              SeasonAddTeamRouteArgs(seasonId: pathParams.optInt('seasonId')));
      return _i18.SeasonAddTeamScreen(
        seasonId: args.seasonId,
        key: args.key,
      );
    },
  );
}

class SeasonAddTeamRouteArgs {
  const SeasonAddTeamRouteArgs({
    this.seasonId,
    this.key,
  });

  final int? seasonId;

  final _i31.Key? key;

  @override
  String toString() {
    return 'SeasonAddTeamRouteArgs{seasonId: $seasonId, key: $key}';
  }
}

/// generated route for
/// [_i19.SeasonFormScreen]
class SeasonFormRoute extends _i30.PageRouteInfo<SeasonFormRouteArgs> {
  SeasonFormRoute({
    int? seasonId,
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          SeasonFormRoute.name,
          args: SeasonFormRouteArgs(
            seasonId: seasonId,
            key: key,
          ),
          rawPathParams: {'seasonId': seasonId},
          initialChildren: children,
        );

  static const String name = 'SeasonFormRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SeasonFormRouteArgs>(
          orElse: () =>
              SeasonFormRouteArgs(seasonId: pathParams.optInt('seasonId')));
      return _i19.SeasonFormScreen(
        seasonId: args.seasonId,
        key: args.key,
      );
    },
  );
}

class SeasonFormRouteArgs {
  const SeasonFormRouteArgs({
    this.seasonId,
    this.key,
  });

  final int? seasonId;

  final _i31.Key? key;

  @override
  String toString() {
    return 'SeasonFormRouteArgs{seasonId: $seasonId, key: $key}';
  }
}

/// generated route for
/// [_i20.SeasonScreen]
class SeasonRoute extends _i30.PageRouteInfo<void> {
  const SeasonRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SeasonRoute.name,
          initialChildren: children,
        );

  static const String name = 'SeasonRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i20.SeasonScreen();
    },
  );
}

/// generated route for
/// [_i21.SelectLeagueScreen]
class SelectLeagueRoute extends _i30.PageRouteInfo<void> {
  const SelectLeagueRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SelectLeagueRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectLeagueRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i21.SelectLeagueScreen();
    },
  );
}

/// generated route for
/// [_i22.SettingsScreen]
class SettingsRoute extends _i30.PageRouteInfo<void> {
  const SettingsRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i22.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i23.SplashScreen]
class SplashRoute extends _i30.PageRouteInfo<void> {
  const SplashRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i23.SplashScreen();
    },
  );
}

/// generated route for
/// [_i24.StadiumFormScreen]
class StadiumFormRoute extends _i30.PageRouteInfo<StadiumFormRouteArgs> {
  StadiumFormRoute({
    int? stadiumId,
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          StadiumFormRoute.name,
          args: StadiumFormRouteArgs(
            stadiumId: stadiumId,
            key: key,
          ),
          rawPathParams: {'stadiumId': stadiumId},
          initialChildren: children,
        );

  static const String name = 'StadiumFormRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<StadiumFormRouteArgs>(
          orElse: () =>
              StadiumFormRouteArgs(stadiumId: pathParams.optInt('stadiumId')));
      return _i24.StadiumFormScreen(
        stadiumId: args.stadiumId,
        key: args.key,
      );
    },
  );
}

class StadiumFormRouteArgs {
  const StadiumFormRouteArgs({
    this.stadiumId,
    this.key,
  });

  final int? stadiumId;

  final _i31.Key? key;

  @override
  String toString() {
    return 'StadiumFormRouteArgs{stadiumId: $stadiumId, key: $key}';
  }
}

/// generated route for
/// [_i25.StadiumScreen]
class StadiumRoute extends _i30.PageRouteInfo<void> {
  const StadiumRoute({List<_i30.PageRouteInfo>? children})
      : super(
          StadiumRoute.name,
          initialChildren: children,
        );

  static const String name = 'StadiumRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i25.StadiumScreen();
    },
  );
}

/// generated route for
/// [_i26.TeamFormScreen]
class TeamFormRoute extends _i30.PageRouteInfo<TeamFormRouteArgs> {
  TeamFormRoute({
    int? teamId,
    _i31.Key? key,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          TeamFormRoute.name,
          args: TeamFormRouteArgs(
            teamId: teamId,
            key: key,
          ),
          rawPathParams: {'teamId': teamId},
          initialChildren: children,
        );

  static const String name = 'TeamFormRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TeamFormRouteArgs>(
          orElse: () => TeamFormRouteArgs(teamId: pathParams.optInt('teamId')));
      return _i26.TeamFormScreen(
        teamId: args.teamId,
        key: args.key,
      );
    },
  );
}

class TeamFormRouteArgs {
  const TeamFormRouteArgs({
    this.teamId,
    this.key,
  });

  final int? teamId;

  final _i31.Key? key;

  @override
  String toString() {
    return 'TeamFormRouteArgs{teamId: $teamId, key: $key}';
  }
}

/// generated route for
/// [_i27.TeamScreen]
class TeamRoute extends _i30.PageRouteInfo<void> {
  const TeamRoute({List<_i30.PageRouteInfo>? children})
      : super(
          TeamRoute.name,
          initialChildren: children,
        );

  static const String name = 'TeamRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i27.TeamScreen();
    },
  );
}

/// generated route for
/// [_i28.UserFormScreen]
class UserFormRoute extends _i30.PageRouteInfo<UserFormRouteArgs> {
  UserFormRoute({
    _i31.Key? key,
    int? userId,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          UserFormRoute.name,
          args: UserFormRouteArgs(
            key: key,
            userId: userId,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'UserFormRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<UserFormRouteArgs>(
          orElse: () => UserFormRouteArgs(userId: pathParams.optInt('userId')));
      return _i28.UserFormScreen(
        key: args.key,
        userId: args.userId,
      );
    },
  );
}

class UserFormRouteArgs {
  const UserFormRouteArgs({
    this.key,
    this.userId,
  });

  final _i31.Key? key;

  final int? userId;

  @override
  String toString() {
    return 'UserFormRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [_i29.UserScreen]
class UserRoute extends _i30.PageRouteInfo<void> {
  const UserRoute({List<_i30.PageRouteInfo>? children})
      : super(
          UserRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i29.UserScreen();
    },
  );
}
