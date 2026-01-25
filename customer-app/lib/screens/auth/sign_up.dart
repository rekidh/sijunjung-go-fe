import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:shared/widgets/custom_text_field.dart';
import 'package:shared/widgets/primary_button.dart';
import 'package:shared/widgets/social_login_button.dart';
import 'package:shared/services/auth_service.dart';
import 'package:shared/utils/preferences_util.dart';
import '../home.dart';
import 'login.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'SofiaPro',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  const CustomTextField(
                    label: 'Full name',
                    hint: 'Your full name',
                  ),

                  const SizedBox(height: 20),

                  const CustomTextField(
                    label: 'E-mail',
                    hint: 'Your email or phone',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  const CustomTextField(
                    label: 'Password',
                    hint: 'Password',
                    isPassword: true,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Center(
                    child: PrimaryButton(
                      text: 'SIGN UP',
                      width: 250,
                      onPressed: () async {
                         // Simulate Sign Up completion
                         // In real app, call AuthService.signUp(...)
                         // Then set onboarding complete just in case
                         await PreferencesUtil().setOnboardingCompleted(true);
                         if (context.mounted) {
                           Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomeScreen()),
                          );
                         }
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontFamily: 'SofiaPro',
                          color: Color(0xFF5A5A5A),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Go back to Login
                        },
                        child: const Text(
                          'Login',
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
                  
                   // Sign up with divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.black.withAlpha(20))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Sign up with',
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
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SocialLoginButton(
                          text: 'Google',
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red), 
                          onPressed: () {},
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
}
