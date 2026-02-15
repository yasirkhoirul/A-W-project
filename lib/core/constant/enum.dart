enum ECourier {
  jne("JNE"),
  sicepat("SI CEPAT"),
  sap("SAP"),
  ide("IDE"),
  jnt("JNT");

  final String text;

  const ECourier(this.text);
}

enum KategoriBarang {
  makanan("makanan"),
  pakaian("pakaian"),
  sepatu("sepatu"),
  elektronik("elektronik");

  final String value;

  const KategoriBarang(this.value);

  static KategoriBarang? fromString(String? value) {
    if (value == null) return null;
    return KategoriBarang.values.firstWhere(
      (e) => e.value == value,
      orElse: () => KategoriBarang.makanan,
    );
  }
}

enum RequestStateCart {
  empty,
  loading,
  loaded,
  pilihkurir,
  pilihmidtrans,
  error,
}

enum ResponseMidtrans {
  capture,
  settlement,
  pending,
  failed,
  deny,
  expire,
  cancel,
}
