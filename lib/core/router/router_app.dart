import 'package:a_and_w/core/router/router.dart';
import 'package:a_and_w/features/auth/persentation/login_page.dart';
import 'package:a_and_w/features/auth/persentation/main_scaffold_auth.dart';
import 'package:a_and_w/features/auth/persentation/signup_page.dart';
import 'package:go_router/go_router.dart';

class RouterApp {
  GoRouter getGoRouter() => GoRouter(
    initialLocation: AppRouter.login,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainScaffoldAuth(navigationShellState: navigationShell,),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.login,
                builder: (context, state) => LoginPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.signup,
                builder: (context, state) => SignupPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
