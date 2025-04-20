import 'package:auto_route/auto_route.dart';
import 'package:sportmatter/config/themes/routes/app_router.gr.dart';
import 'package:sportmatter/config/themes/routes/auth_guard.dart';
import 'package:sportmatter/config/themes/routes/guest_guard.dart';
import 'package:sportmatter/config/themes/routes/role_guard.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {

  final AuthGuard authGuard;
  final RoleGuard superAdminGuard;
  final RoleGuard managerGuard;
  final GuestGuard guestGuard;

  AppRouter({required this.authGuard, required this.managerGuard, required this.guestGuard, required this.superAdminGuard, super.navigatorKey});

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/', page: SplashRoute.page, initial: true),
    AutoRoute(path: '/login', page: LoginRoute.page, guards: [guestGuard]),
    AutoRoute(path: '/home', page: HomeRoute.page, guards: [authGuard]),
    AutoRoute(path: '/forgot-password', page: ForgotPasswordRoute.page),
    AutoRoute(path: '/settings', page: SettingsRoute.page, guards: [authGuard]),
    AutoRoute(path: '/profile', page: ProfileRoute.page, guards: [authGuard]),
    AutoRoute(path: '/change-password', page: ResetPasswordRoute.page, guards: [authGuard]),

    AutoRoute(path: '/countries', page: CountryRoute.page, guards: [managerGuard]),
    AutoRoute(
      path: '/countries/form',
      page: CountryFormRoute.page,
      guards: [managerGuard],
    ),
    AutoRoute(
      path: '/countries/form/:countryId',
      page: CountryFormRoute.page,
        guards: [managerGuard],
    ),


    AutoRoute(path: '/teams', page: TeamRoute.page, guards: [managerGuard],),
    AutoRoute(path: '/teams/form', page: TeamFormRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/teams/form/:teamId', page: TeamFormRoute.page,guards: [managerGuard]),


    AutoRoute(path: '/stadium', page: StadiumRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/stadium/form', page: StadiumFormRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/stadium/form/:stadiumId', page: StadiumFormRoute.page,guards: [managerGuard]),

    AutoRoute(path: '/referee', page: RefereeRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/referee/form', page: RefereeFormRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/referee/form/:refereeId', page: RefereeFormRoute.page,guards: [managerGuard]),

    AutoRoute(path: '/player', page: PlayerRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/player/form', page: PlayerFormRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/player/form/:playerId', page: PlayerFormRoute.page,guards: [managerGuard]),


    AutoRoute(path: '/league', page: LeagueRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/league/form', page: LeagueFormRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/league/form/:leagueId', page: LeagueFormRoute.page,guards: [managerGuard]),


    AutoRoute(path: '/season', page: SeasonRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/season/form', page: SeasonFormRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/season/form/:seasonId', page: SeasonFormRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/season/addTeams/:seasonId', page: SeasonAddTeamRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/season/addTeams/form/:seasonId', page: SeasonAddTeamFormRoute.page,guards: [managerGuard]),

    AutoRoute(path: '/match', page: MatchRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/match/league', page: SelectLeagueRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/match/management/:matchId', page: MatchManagementRoute.page,guards: [managerGuard]),
    AutoRoute(path: '/match/add/:id', page: MatchFormRoute.page,guards: [managerGuard]),

    AutoRoute(path: '/user', page: UserRoute.page, guards: [superAdminGuard]),
    AutoRoute(path: '/user/form', page: UserFormRoute.page, guards: [superAdminGuard]),
    AutoRoute(path: '/user/form/:userId', page: UserFormRoute.page, guards: [superAdminGuard]),

    RedirectRoute(path: '*', redirectTo: '/'),
  ];
}
