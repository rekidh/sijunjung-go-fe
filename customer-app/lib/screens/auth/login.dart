import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:shared/widgets/custom_text_field.dart';
import 'package:shared/widgets/primary_button.dart';
import 'package:shared/widgets/social_login_button.dart';
import 'package:shared/services/auth_service.dart';
import '../home.dart';
import '../onboarding/welcome.dart';
import 'sign_up.dart';
import 'phone_registration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SocialAuthMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.login(email, password);
      
      if (!mounted) return;

      if (response.success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          Positioned.fill(
            child: Image.asset(
              'assets/images/auth-background.png',
              package: 'shared',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left, color: Colors.black),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'SofiaPro',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  CustomTextField(
                    controller: _emailController,
                    label: 'E-mail',
                    hint: 'Your email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Password',
                    isPassword: true,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        // Implementasi Reset Password nanti
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontFamily: 'SofiaPro',
                          color: Color(0xFF55B6E7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PhoneRegistration()),
                        );
                      },
                      child: const Text(
                        'Login with Phone Number',
                        style: TextStyle(
                          fontFamily: 'SofiaPro',
                          color: Color(0xFF55B6E7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Center(
                    child: PrimaryButton(
                      text: 'LOGIN',
                      width: 250,
                      isLoading: _isLoading,
                      onPressed: _handleLogin,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontFamily: 'SofiaPro',
                          color: Color(0xFF5A5A5A),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'SofiaPro',
                            color: Color(0xFF55B6E7),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                   // Sign in with divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.black.withAlpha(20))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Sign in with',
                          style: TextStyle(
                            fontFamily: 'SofiaPro',
                            color: const Color(0xFF5A5A5A).withAlpha(200),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.black.withAlpha(20))),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Row(
                    children: [
                      Expanded(
                        child: SocialLoginButton(
                          text: 'Facebook',
                          icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
                          onPressed: isSocialLoading || _isLoading ? null : () => handleFacebookSignIn(onSuccess: _onSocialSuccess),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SocialLoginButton(
                          text: 'Google',
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red), 
                          onPressed: isSocialLoading || _isLoading ? null : () => handleGoogleSignIn(onSuccess: _onSocialSuccess),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
