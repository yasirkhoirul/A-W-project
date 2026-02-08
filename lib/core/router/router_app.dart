import 'package:a_and_w/core/router/auth_router_listener.dart';
import 'package:a_and_w/core/router/router.dart';
import 'package:a_and_w/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:a_and_w/features/auth/presentation/page/login_page.dart';
import 'package:a_and_w/features/auth/presentation/page/profile_page.dart';
import 'package:a_and_w/features/auth/presentation/page/signup_page.dart';
import 'package:a_and_w/core/main_scaffold/main_scaffold.dart';
import 'package:a_and_w/features/barang/persentation/page/barang_page.dart';
import 'package:go_router/go_router.dart';

class RouterApp {
  final AuthBloc authBloc;
  const RouterApp(this.authBloc);
  GoRouter getGoRouter() => GoRouter(
    refreshListenable: AuthRouterListener(bloc: authBloc),
    initialLocation: AppRouter.login,
    routes: [
      GoRoute(path: AppRouter.login, builder: (context, state) => LoginPage()),
      GoRoute(
        path: AppRouter.signup,
        builder: (context, state) => SignupPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainScaffold(navigationShell: navigationShell,),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.home,
                builder: (context, state) => ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final bool isLoggedIN = authBloc.state is AuthSuccess;
      final unsecurePahths = [AppRouter.login, AppRouter.signup];
      final isInUnsecurePath = unsecurePahths.contains(state.fullPath);
      if (!isLoggedIN && !isInUnsecurePath) {
        return AppRouter.login;
      } else if (isLoggedIN && isInUnsecurePath) {
        return AppRouter.home;
      }
      return null;
    },
  );
}
