import 'package:a_and_w/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:a_and_w/features/auth/presentation/bloc/profile_bloc.dart';
import 'package:a_and_w/features/auth/presentation/page/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';

class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainScaffold({super.key, required this.navigationShell});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  void cekToken() async {
  User? user = FirebaseAuth.instance.currentUser;
  
  if (user != null) {
    // True berarti memaksa refresh token baru biar masa berlakunya panjang
    String? token = await user.getIdToken(true);
    
    print("================ COPY TOKEN DI BAWAH INI ================");
    print(token);
    print("=========================================================");
    
    print("UID SAYA: ${user.uid}");
  } else {
    print("User belum login");
  }
}
  @override
  void initState() {
    cekToken();
    context.read<ProfileBloc>().add(OnGetProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barang"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(OnLogoutEvent());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            Logger().d('Profile loaded: dipanggil');
            if (state.profile.phoneNumber == null ||
                state.profile.address == null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Lengkapi Profil'),
                  content: ContenProfile(profile: state.profile), 
                ),
              );
            }
          }
        },
        child: Center(child: widget.navigationShell),
      ),
    );
  }
}
