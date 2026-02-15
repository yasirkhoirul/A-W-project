import 'package:a_and_w/core/entities/profile.dart';
import 'package:a_and_w/core/utils/validators.dart';
import 'package:a_and_w/core/widgets/button.dart';
import 'package:a_and_w/core/widgets/form_layout.dart';
import 'package:a_and_w/core/widgets/snackbar.dart';
import 'package:a_and_w/features/pengantaran/presentation/pages/alamat_row.dart';
import 'package:a_and_w/core/widgets/error_retry.dart';
import 'package:a_and_w/core/widgets/text_field.dart';
import 'package:a_and_w/features/auth/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(OnGetProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          CustomSnackBar.showError(context, 'Terjadi kesalahan${state.message}');
        }
        if (state is ProfileLoaded) {
          CustomSnackBar.showSuccess(context, 'Profile berhasil diload');
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: ContentProfile(profile: state.profile),
            ),
          );
        } else if (state is ProfileError) {
          return ErrorRetry(
            message: "Gagal load data",
            onRetry: () => context.read<ProfileBloc>().add(OnGetProfile()),
          );
        } else {
          return const Center(child: Text('Welcome to Profile Page'));
        }
      },
    );
  }
}

class ContentProfile extends StatefulWidget {
  const ContentProfile({super.key, required this.profile});

  final Profile profile;

  @override
  State<ContentProfile> createState() => _ContentProfileState();
}

class _ContentProfileState extends State<ContentProfile> {
  late final TextEditingController _namaController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  Address? _address;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.profile.nama);
    _phoneController = TextEditingController(
      text: widget.profile.phoneNumber ?? '',
    );
    _address = widget.profile.address;
  }

  @override
  void didUpdateWidget(ContentProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _namaController.text = widget.profile.nama;
      _phoneController.text = widget.profile.phoneNumber ?? '';
      _address = widget.profile.address;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Form(
          key: _formKey,
          child: FormLayout(
            children: [
              Text(
                "Selamat Datang Di Profile",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              CircleAvatar(
                radius: 100,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Email: ${widget.profile.email}'),
              ),
              MyTextField(label: 'Nama', controller: _namaController),
              MyTextField(
                label: 'Nomor Telepon',
                controller: _phoneController,
                validator: Validators.phone,
              ),
              AlamatRow(
                onUpdatingChanged: (value) {
                  setState(() {
                    isUpdating = value;
                  });
                },
                _address,
                onAlamatSubmitted: (newAddress) {
                  setState(() {
                    _address = newAddress;
                  });
                },
              ),

              MyButton(
                isLoading: isUpdating,
                text: "Simpan",
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  if(_address == null) {
                    CustomSnackBar.showError(context, 'Alamat harus diisi');
                    return;
                  }
                  final Profile updatedProfile = Profile(
                    uid: widget.profile.uid,
                    email: widget.profile.email,
                    nama: _namaController.text,
                    phoneNumber: _phoneController.text,
                    address: _address,
                  );

                  context.read<ProfileBloc>().add(
                    OnUpdateProfile(updatedProfile),
                  );
                },
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
