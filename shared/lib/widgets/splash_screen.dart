import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../utils/preferences_util.dart';

class SplashScreen extends StatefulWidget {
  final Widget homeScreen;
  final Widget loginScreen;
  final Widget? welcomeScreen; // Optional now

  const SplashScreen({
    super.key,
    required this.homeScreen,
    required this.loginScreen,
    this.welcomeScreen,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();
  final PreferencesUtil _preferencesUtil = PreferencesUtil();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
     _preferencesUtil.resetOnboarding(); // Uncomment locally if needed for testing
    }
    _checkNavigation();
  }

  void _checkNavigation() async {
    bool loggedIn = await _authService.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.homeScreen),
      );
    } else {
      // If welcomeScreen is provided, we check onboarding status
      if (widget.welcomeScreen != null) {
        bool onboardingCompleted = await _preferencesUtil.hasCompletedOnboarding();
        if (!mounted) return;
        
        if (onboardingCompleted) {
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => widget.loginScreen),
          );
        } else {
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => widget.welcomeScreen!),
          );
        }
      } else {
        // Fallback for apps without onboarding (straight to logic)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => widget.loginScreen),
        );
      }
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                  ),
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