class AuthService {
  // Simulasi cek login
  // nanti bisa diganti pakai Firebase / API
  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(seconds: 2)); // simulasi loading
    return false; // ubah ke `true` untuk test login
  }
}
