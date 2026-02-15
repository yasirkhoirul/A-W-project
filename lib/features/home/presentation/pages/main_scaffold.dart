import 'package:a_and_w/core/entities/nav_item.dart';
import 'package:a_and_w/core/widgets/custom_app_bar.dart';
import 'package:a_and_w/core/widgets/complete_profile_dialog.dart';
import 'package:a_and_w/core/widgets/custom_bot_nav.dart';
import 'package:a_and_w/core/widgets/fab_cart.dart';
import 'package:a_and_w/core/widgets/my_lottie_animation.dart';
import 'package:a_and_w/features/auth/presentation/bloc/profile_bloc.dart';
import 'package:a_and_w/features/barang/presentation/cubit/keranjang_cubit.dart';
import 'package:a_and_w/features/barang/presentation/page/keranjang_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainScaffold({super.key, required this.navigationShell});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    context.read<ProfileBloc>().add(OnGetProfile());

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      floatingActionButton: widget.navigationShell.currentIndex == 0
          ? BlocBuilder<KeranjangCubit, KeranjangState>(
              builder: (context, state) {
                return FabCart(
                  onPressed: () {
                    KeranjangBottomSheet.show(context);
                  },
                  itemCount: state is KeranjangLoaded ? state.totalItems : 0,
                );
              },
            )
          : null,
      extendBody: true,
      bottomNavigationBar: CustomBotNav(
        selectedIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(index);
        },
        items: [
          NavItem(icon: Icons.home, label: 'Home'),
          NavItem(icon: Icons.person, label: 'Profile'),
          NavItem(icon: Icons.shopping_cart, label: 'History'),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            if (state.profile.phoneNumber == null ||
                state.profile.address == null) {
              CompleteProfileDialog.show(context);
            }
          }
        },
        child: Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: SlideTransition(
                position: _slideAnimation,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: MyLottieAnimation(),
                ),
              ),
            ),
            Center(child: widget.navigationShell),
          ],
        ),
      ),
    );
  }
}
