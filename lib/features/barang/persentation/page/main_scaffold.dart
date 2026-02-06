import 'package:a_and_w/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScaffold extends StatelessWidget{
  
  const MainScaffold({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Barang"),actions: [
        IconButton(
          onPressed: (){
            context.read<AuthBloc>().add(OnLogoutEvent());
          },
          icon: const Icon(Icons.logout),
        ),
      ],),
      body: const Center(
        child: Text("Main Scaffold Barang Page"),
      ),
    );
  }
}