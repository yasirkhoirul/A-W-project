import 'package:a_and_w/core/dependency_injection.dart';
import 'package:a_and_w/core/router/auth_router_listener.dart';
import 'package:a_and_w/core/router/router.dart';
import 'package:a_and_w/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:a_and_w/features/auth/presentation/page/login_page.dart';
import 'package:a_and_w/features/auth/presentation/page/profile_page.dart';
import 'package:a_and_w/features/auth/presentation/page/signup_page.dart';
import 'package:a_and_w/features/barang/domain/entities/keranjang_entity.dart';
import 'package:a_and_w/features/barang/presentation/page/barang_page.dart';
import 'package:a_and_w/features/barang/presentation/page/detail_barang_page.dart';
import 'package:a_and_w/features/history/presentation/cubit/history_cubit.dart';
import 'package:a_and_w/features/history/presentation/pages/detail_history_page.dart';
import 'package:a_and_w/features/history/presentation/pages/history_page.dart';
import 'package:a_and_w/features/home/presentation/pages/main_scaffold.dart';
import 'package:a_and_w/features/home/presentation/pages/splash_page.dart';
import 'package:a_and_w/features/pembayaran/pembayaran_page.dart';
import 'package:a_and_w/features/pengantaran/presentation/bloc/pengantara_check_track_bloc.dart';
import 'package:a_and_w/features/pengantaran/presentation/pages/lacak_page.dart';
import 'package:a_and_w/features/pesanan/presentation/pages/pesanan_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RouterApp {
  final AuthBloc authBloc;
  const RouterApp(this.authBloc);
  GoRouter getGoRouter() => GoRouter(
    refreshListenable: AuthRouterListener(bloc: authBloc),
    initialLocation: AppRouter.splash,
    routes: [
      GoRoute(
        path: AppRouter.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: "${AppRouter.pembayaran}/:url",
        name: AppRouter.pembayaran,
        builder: (context, state) {
          final url = state.pathParameters['url'] ?? '';
          return PembayaranPage(url: url);
        },
      ),
      GoRoute(
        name: AppRouter.pesanan,
        path: AppRouter.pesanan,
        builder: (context, state) {
          final datalist = state.extra as List<KeranjangEntity>? ?? [];
          return PesananPage(dataList: datalist);
        },
      ),
      GoRoute(path: AppRouter.login, builder: (context, state) => LoginPage()),
      GoRoute(
        path: AppRouter.signup,
        builder: (context, state) => SignupPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.home,
                builder: (context, state) => BarangPage(),
                routes: [
                  GoRoute(
                    name: AppRouter.detailBarang,
                    path: "${AppRouter.detailBarang}/:id",
                    builder: (context, state) {
                      final barangId = state.pathParameters['id'] ?? '';
                      return DetailBarang(barangId: barangId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.profile,
                builder: (context, state) => ProfilePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.history,
                builder: (context, state) => const HistoryPage(),
                routes: [
                  GoRoute(
                    name: AppRouter.detailHistory,
                    path: '${AppRouter.detailHistory}/:orderId',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId'] ?? '';
                      return BlocProvider(
                        create: (_) => locator<HistoryDetailCubit>(),
                        child: DetailHistoryPage(orderId: orderId),
                      );
                    },
                    routes: [
                      GoRoute(
                        name: AppRouter.lacak,
                        path:
                            '${AppRouter.lacak}/:waybill/:courier/:lastPhoneNumber',
                        builder: (context, state) {
                          final waybill = state.pathParameters['waybill'] ?? '';
                          final courier = state.pathParameters['courier'] ?? '';
                          final lastPhoneNumber =
                              int.tryParse(
                                state.pathParameters['lastPhoneNumber'] ?? '0',
                              ) ??
                              0;
                          return BlocProvider(
                            create: (_) => locator<PengantaraCheckTrackBloc>(),
                            child: LacakPage(
                              waybill: waybill,
                              courier: courier,
                              lastPhoneNumber: lastPhoneNumber,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final bool isLoggedIN =
          authBloc.state is AuthSuccess || authBloc.state is AuthLoadingLogout;
      final unsecurePaths = [
        AppRouter.login,
        AppRouter.signup,
        AppRouter.splash,
      ];
      final isInUnsecurePath = unsecurePaths.contains(state.fullPath);
      if (!isLoggedIN && !isInUnsecurePath) {
        return AppRouter.login;
      } else if (isLoggedIN && isInUnsecurePath) {
        return AppRouter.home;
      }
      return null;
    },
  );
}
