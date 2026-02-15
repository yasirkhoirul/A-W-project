class Validators {
  static String? required(String? value, {String fieldName = "Field"}) {
    if (value == null || value.isEmpty) {
      return "$fieldName tidak boleh kosong";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return "Email tidak boleh kosong";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Format email tidak valid";
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return "Nomor HP tidak boleh kosong";
    }
    final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');
    if (!phoneRegex.hasMatch(value)) {
      return "Nomor HP tidak valid (contoh: 081234567890)";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password tidak boleh kosong";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }
    return null;
  }

  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return "Konfirmasi password tidak boleh kosong";
    }
    if (value != originalPassword) {
      return "Password tidak sama";
    }
    return null;
  }
}
