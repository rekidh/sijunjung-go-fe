class AuthService {
  // Simulasi cek login
  // nanti bisa diganti pakai Firebase / API
  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(seconds: 5)); // simulasi loading
    return true; // ubah ke `true` untuk test login
  }
}
