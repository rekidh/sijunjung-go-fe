import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  final Widget homeScreen;
  final Widget loginScreen;

  const SplashScreen({
    super.key,
    required this.homeScreen,
    required this.loginScreen,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    bool loggedIn = await _authService.isLoggedIn();

    // pindah ke halaman sesuai status login
    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.homeScreen),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.loginScreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF55B6E7),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo/sijunjung-go.png',
                    package: 'shared',
                    width: 90,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'Sijunjung Go',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold,),
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}