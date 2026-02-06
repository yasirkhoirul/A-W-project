import 'package:a_and_w/core/dependency_injection.dart';
import 'package:a_and_w/core/router/router_app.dart';
import 'package:a_and_w/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:a_and_w/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await getitInit();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<AuthBloc>()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: RouterApp(locator<AuthBloc>()).getGoRouter());
  }
}
