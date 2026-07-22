import 'package:go_router/go_router.dart';
import '../features/player/presentation/create_profile_page.dart';
import '../features/achievements/presentation/achievements_page.dart';
import '../features/base/presentation/base_page.dart';
import '../features/games/clasificaton/presentation/clasificaton_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/settings/presentation/settings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/base', builder: (context, state) => const BasePage()),
    GoRoute(path: '/', builder: (context, state) => const CreateProfilePage()),
    GoRoute(
      path: '/clasificaton',
      builder: (context, state) => const ClasificatonPage(),
    ),

    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),

    GoRoute(
      path: '/achievements',
      builder: (context, state) => const AchievementsPage(),
    ),

    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
