import 'package:a_and_w/core/constant/theme.dart';
import 'package:a_and_w/core/dependency_injection.dart';
import 'package:a_and_w/core/router/router_app.dart';
import 'package:a_and_w/core/utils/local_notification.dart';
import 'package:a_and_w/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:a_and_w/features/auth/presentation/bloc/profile_bloc.dart';
import 'package:a_and_w/features/barang/presentation/cubit/barang_cubit.dart';
import 'package:a_and_w/features/barang/presentation/cubit/detail_barang_cubit.dart';
import 'package:a_and_w/features/barang/presentation/cubit/keranjang_cubit.dart';
import 'package:a_and_w/features/history/presentation/cubit/history_cubit.dart';
import 'package:a_and_w/features/pengantaran/presentation/bloc/pengantara_check_track_bloc.dart';
import 'package:a_and_w/features/pesanan/presentation/bloc/pesanan_bloc.dart';
import 'package:a_and_w/features/pesanan/presentation/cubit/get_pesanan_cubit.dart';
import 'package:a_and_w/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await getitInit();
  await locator<FirebaseMessaging>().requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  final localNotificationService = LocalNotificationService(
    plugin: locator<FlutterLocalNotificationsPlugin>(),
    messaging: locator<FirebaseMessaging>(),
  );
  await localNotificationService.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<AuthBloc>()),
        BlocProvider(create: (context) => locator<ProfileBloc>()),
        BlocProvider(create: (context) => locator<PengantaraCheckTrackBloc>()),
        BlocProvider(create: (context) => locator<BarangCubit>()),
        BlocProvider(
          create: (context) => locator<KeranjangCubit>()..loadKeranjang(),
        ),
        BlocProvider(create: (context) => locator<DetailBarangCubit>()),
        BlocProvider(create: (context) => locator<PesananBloc>()),
        BlocProvider(create: (context) => locator<GetPesananCubit>()),
        BlocProvider(create: (context) => locator<HistoryCubit>()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: theme,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        useMaterial3: true,
      ),
      routerConfig: RouterApp(locator<AuthBloc>()).getGoRouter(),
    );
  }
}
