import 'package:a_and_w/core/dependency_injection.dart';
import 'package:a_and_w/core/utils/validators.dart';
import 'package:a_and_w/core/widgets/error_retry.dart';
import 'package:a_and_w/core/widgets/text_field.dart';
import 'package:a_and_w/features/auth/domain/entities/profile.dart';
import 'package:a_and_w/features/auth/presentation/bloc/profile_bloc.dart';
import 'package:a_and_w/features/pengantaran/presentation/cubit/alamat_dropdown_cubit.dart';
import 'package:a_and_w/features/pengantaran/presentation/pages/pick_alamat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Terjadi kesalahan')));
        }
        if (state is ProfileLoaded) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Profile berhasil diload')));
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          return ContenProfile(profile: state.profile);
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

class ContenProfile extends StatefulWidget {
  const ContenProfile({super.key, required this.profile});

  final Profile profile;

  @override
  State<ContenProfile> createState() => _ContenProfileState();
}

class _ContenProfileState extends State<ContenProfile> {
  late final TextEditingController _namaController;
  late final TextEditingController _phoneController;
  Address? _address;
  final _formKey = GlobalKey<FormState>();
  bool isUpdating = false;

  double _turns = 0.0;

  void _rotateIcon() {
    setState(() {
      _turns += 0.5;
    });
  }

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
  void didUpdateWidget(ContenProfile oldWidget) {
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
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(label: 'Nama', controller: _namaController),
            const SizedBox(height: 16),
            Text('Email: ${widget.profile.email}'),
            const SizedBox(height: 16),
            MyTextField(
              label: 'Nomor Telepon',
              controller: _phoneController,
              validator: Validators.phone,
            ),
            const SizedBox(height: 16),
            _address == null
                ? const Text("Alamat belum ditambahkan")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Alamat: "),
                      Flexible(
                        child: !isUpdating
                            ? Text(
                                "${_address!.district.nama}, ${_address!.kota.nama}, ${_address!.provinsi.nama}",
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text("Pilih Alamat"),
                      ),
                      AnimatedRotation(
                        turns: _turns, // Nilai ini yang diubah-ubah
                        duration: const Duration(
                          milliseconds: 500,
                        ), // Durasi animasi
                        curve: Curves.easeInOut, // Efek gerakan agar halus
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isUpdating = !isUpdating;
                            });
                            _rotateIcon();
                          },
                          icon: const Icon(Icons.arrow_drop_up_rounded),
                        ),
                      ),
                    ],
                  ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: isUpdating
                  ? BlocProvider(
                      create: (context) => locator<AlamatDropdownCubit>(),
                      child: PickAlamatPage(
                        onAlamatSubmitted: (provinsi, kota, distrik) {
                          final dataProv = DataAddress(
                            id: provinsi.id!,
                            nama: provinsi.name!,
                          );
                          final dataKota = DataAddress(
                            id: kota.id!,
                            nama: kota.name!,
                          );
                          final dataDistrik = DataAddress(
                            id: distrik.id!,
                            nama: distrik.name!,
                          );
                          setState(() {
                            _address = Address(
                              provinsi: dataProv,
                              kota: dataKota,
                              district: dataDistrik,
                            );
                             setState(() {
                              isUpdating = !isUpdating;
                            });
                            _rotateIcon();
                          });
                        },
                      ),
                    )
                  : Container(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
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
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
