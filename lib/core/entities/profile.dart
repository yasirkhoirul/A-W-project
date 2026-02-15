      import 'package:equatable/equatable.dart';

/// Shared entity untuk user profile
/// Digunakan di auth feature dan features lain yang butuh info user
class Profile extends Equatable {
  final String uid;
  final String email;
  final String nama;
  final String? phoneNumber;
  final Address? address;

  const Profile({
    required this.uid,
    required this.email,
    required this.nama,
    this.phoneNumber,
    this.address,
  });

  @override
  List<Object?> get props => [uid, email, nama, phoneNumber, address];
}

/// Address entity untuk alamat user
class Address extends Equatable {
  final DataAddress provinsi;
  final DataAddress kota;
  final DataAddress district;

  const Address({
    required this.provinsi,
    required this.kota,
    required this.district,
  });

  @override
  List<Object?> get props => [provinsi, kota, district];
}

/// Data alamat (provinsi/kota/distrik)
class DataAddress extends Equatable {
  final int id;
  final String nama;

  const DataAddress({
    required this.id,
    required this.nama,
  });

  @override
  List<Object?> get props => [id, nama];
}
