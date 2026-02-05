import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffoldAuth extends StatelessWidget {
  final StatefulNavigationShell navigationShellState;
  const MainScaffoldAuth({super.key, required this.navigationShellState});

  @override
  Widget build(BuildContext context) {
    final index = navigationShellState.currentIndex;
    return Scaffold(
      appBar: AppBar(
        title: Text(title(index)),
      ),
      body: SafeArea(child: 
        navigationShellState),
    );
  }

  String title(int index) {
    if (index == 0) return 'Login';
    if (index == 1) return 'Sign Up';
    return 'A&W';
  }
}