import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:shared/utils/preferences_util.dart';
import '../auth/login.dart';
import '../auth/phone_registration.dart';
import 'package:shared/services/auth_service.dart';
import '../home.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SocialAuthMixin {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _completeOnboarding(BuildContext context) async {
    await PreferencesUtil().setOnboardingCompleted(true);
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _onSocialSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome-background.png',
              package: 'shared',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withAlpha(150), // 150/255 ~= 0.6 opacity
                    Colors.white.withAlpha(50),  // 50/255 ~= 0.2 opacity
                    Colors.black.withAlpha(100), // 100/255 ~= 0.4 opacity
                    Colors.black.withAlpha(200), // 200/255 ~= 0.8 opacity
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skip Button
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => _completeOnboarding(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // Welcome Text
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'SofiaPro',
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.1,
                      ),
                      children: const [
                        TextSpan(text: 'Welcome to\n'),
                        TextSpan(
                          text: 'SGO',
                          style: TextStyle(
                            color: Color(0xFF55B6E7), // SGO Blue color
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subtitle
                  const Text(
                    'Your favourite foods delivered\nfast at your door.',
                    style: TextStyle(
                      fontFamily: 'SofiaPro',
                      fontSize: 18,
                      color: Color(0xFF5A5A5A), 
                      height: 1.5,
                    ),
                  ),
                  
                  const Spacer(flex: 3),
                  
                  // Sign in with divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white.withAlpha(128))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'sign in with',
                          style: TextStyle(
                            fontFamily: 'SofiaPro',
                            color: Colors.white.withAlpha(230),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white.withAlpha(128))),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Social Buttons
                  Row(
                    children: [
                      // Facebook Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isSocialLoading ? null : () => handleFacebookSignIn(onSuccess: _onSocialSuccess),
                          icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
                          label: const Text('FACEBOOK'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'SofiaPro',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                               letterSpacing: 1.1
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Google Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isSocialLoading ? null : () => handleGoogleSignIn(onSuccess: _onSocialSuccess),
                          // Initial Google Icon attempt - using font awesome or colored asset usually preferred for brand compliance
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red), 
                          label: const Text('GOOGLE'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'SofiaPro',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.1
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Start with email or phone
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PhoneRegistration()),
                      ),

                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withAlpha(50),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withAlpha(200)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Start with email or phone',
                        style: TextStyle(
                          fontFamily: 'SofiaPro',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Already have an account text
                  Center(
                    child: GestureDetector(
                      onTap: () => _completeOnboarding(context),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'SofiaPro',
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Sign In',
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
