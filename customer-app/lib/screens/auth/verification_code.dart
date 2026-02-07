import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:shared/services/auth_service.dart';
import '../home.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String identifier;
  final bool isPhone;
  const VerificationCodeScreen({
    super.key, 
    required this.identifier, 
    this.isPhone = false,
  });

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _verifyOtp(String code) async {
    setState(() => _isLoading = true);
    try {
      final response = widget.isPhone 
          ? await _authService.verifyWhatsAppOtp(widget.identifier, code)
          : await _authService.verifyOtp(widget.identifier, code);
          
      if (!mounted) return;

      if (response.success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
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
                   // Back Button
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
                    'Verification Code',
                    style: TextStyle(
                      fontFamily: 'SofiaPro',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    'Please type the verification code sent to\n${widget.identifier}',
                    style: const TextStyle(
                      fontFamily: 'SofiaPro',
                      fontSize: 16,
                      color: Color(0xFF9796A1),
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // OTP Field
                  Center(
                    child: _isLoading 
                      ? const CircularProgressIndicator()
                      : OtpDigitField(
                        length: 4,
                        onCompleted: _verifyOtp,
                      ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Resend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "I don’t receive a code! ",
                        style: TextStyle(
                          fontFamily: 'SofiaPro',
                          color: Color(0xFF5A5A5A),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // TODO: Implement resend-otp in AuthService
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Resending code...')),
                          );
                        },
                        child: const Text(
                          'Please resend',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
