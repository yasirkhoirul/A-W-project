import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffoldAuth extends StatelessWidget {
  final StatefulNavigationShell navigationShellState;
  const MainScaffoldAuth({super.key, required this.navigationShellState});

  @override
  Widget build(BuildContext context) {
    final index = navigationShellState.currentIndex;
    return Scaffold(
      appBar: AppBar(title: Text(title(index)["title"])),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "By continuing, you agree to our Terms of Service and Privacy Policy.",
          ),
          ElevatedButton(onPressed: title(index)["onPressed"], child: Text("Continue with Google")),
          ElevatedButton(onPressed: title(index)["onPressed"], child: Text(title(index)["title"])),
        ],
      ),
      body: SafeArea(child: SingleChildScrollView(child: navigationShellState)),
    );
  }

  Map<String, dynamic> title(int index) {
    if (index == 0) {
      return {"title": 'Login', "onPressed": () {}};
    }
    if (index == 1) {
      return {"title": 'Sign Up', "onPressed": () {}};
    }
    return {"title": 'A&W', "onPressed": () {}};
  }
}
