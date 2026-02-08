class Profile {
  final String uid;
  final String email;
  final String nama;
  final String? phoneNumber;
  final List<Address>? address;
  const Profile({
    required this.uid,
    required this.email,
    required this.nama,
    required this.phoneNumber,
    required this.address,
  });
}

class Address {
  final DataAddress provinsi;
  final DataAddress kota;
  final DataAddress district;
  const Address({
    required this.provinsi,
    required this.kota,
    required this.district,
  });
}

class DataAddress {
  final int id;
  final String nama;
  const DataAddress({required this.id, required this.nama});
}
