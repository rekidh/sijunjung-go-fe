import 'package:flutter/material.dart';
import 'package:shared/widgets/custom_text_field.dart';
import 'package:shared/widgets/primary_button.dart';
import 'package:shared/shared.dart';
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

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
                    'Reset Password',
                    style: TextStyle(
                      fontFamily: 'SofiaPro',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  const Text(
                    'Please enter your email address to\nrequest a password reset',
                    style: TextStyle(
                      fontFamily: 'SofiaPro',
                      fontSize: 16,
                      color: Color(0xFF9796A1),
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  const CustomTextField(
                    label: '', 
                    hint: 'sijunjunggo@gmail.com', // Placeholder? Or prefilled? Assuming input hint.
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Center(
                    child: PrimaryButton(
                      text: 'SEND NEW PASSWORD',
                      width: 250,
                      onPressed: () {
                        // Simulate sending email
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reset link sent to your email')),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
