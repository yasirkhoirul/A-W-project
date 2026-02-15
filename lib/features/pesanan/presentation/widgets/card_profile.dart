import 'package:a_and_w/core/entities/profile.dart';
import 'package:a_and_w/core/utils/validators.dart';
import 'package:a_and_w/core/widgets/form_layout.dart';
import 'package:a_and_w/core/widgets/text_field.dart';
import 'package:a_and_w/features/auth/presentation/bloc/profile_bloc.dart';
import 'package:a_and_w/features/pengantaran/presentation/pages/alamat_row.dart';
import 'package:a_and_w/features/pesanan/domain/entities/cart_entity.dart';
import 'package:a_and_w/features/pesanan/presentation/bloc/pesanan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardProfile extends StatefulWidget {
  final CartUserEntity user;
  final Function(Address) onAlamatChange;

  const CardProfile({
    super.key,
    required this.user,
    required this.onAlamatChange,
  });

  @override
  State<CardProfile> createState() => _CardProfileState();
}

class _CardProfileState extends State<CardProfile> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController(text: widget.user.email ?? '');
    _phoneController = TextEditingController(
      text: widget.user.phoneNumber ?? '',
    );
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded) {
      _nameController.text = profileState.profile.nama;
      context.read<PesananBloc>().add(
        OnUpdateUserInfo(displayName: profileState.profile.nama),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FormLayout(
          children: [
            const Text(
              'Informasi Pembeli',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            MyTextField(
              label: 'Nama',
              controller: _nameController,
              onChanged: (value) {
                context.read<PesananBloc>().add(
                  OnUpdateUserInfo(displayName: value),
                );
              },
            ),
            MyTextField(
              label: 'Email',
              validator: Validators.email,
              controller: _emailController,
              onChanged: (value) {
                context.read<PesananBloc>().add(OnUpdateUserInfo(email: value));
              },
            ),
            MyTextField(
              label: 'Phone',
              validator: Validators.phone,
              controller: _phoneController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                context.read<PesananBloc>().add(
                  OnUpdateUserInfo(phoneNumber: value),
                );
              },
            ),
            AlamatRow(
              widget.user.address,
              onUpdatingChanged: (value) {},
              onAlamatSubmitted: widget.onAlamatChange,
            ),
          ],
        ),
      ),
    );
  }
}
