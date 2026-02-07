import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:shared/services/auth_service.dart';
import 'verification_code.dart';

class PhoneRegistration extends StatefulWidget {
  const PhoneRegistration({super.key});

  @override
  State<PhoneRegistration> createState() => _PhoneRegistrationState();
}

class _PhoneRegistrationState extends State<PhoneRegistration> {
  final TextEditingController _phoneController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleSend() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _authService.sendWhatsAppOtp(phone);
      if (!mounted) return;

      if (response.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationCodeScreen(
              identifier: phone,
              isPhone: true,
            ),
          ),
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
          // ===== BACKGROUND =====
          Positioned.fill(
            child: Image.asset(
              'assets/images/auth-background.png',
              package: 'shared',
              fit: BoxFit.cover,
            ),
          ),

          // ===== CONTENT =====
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
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
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        'Registration',
                        style: TextStyle(
                          fontFamily: 'SofiaPro',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Enter your phone number to verify your account',
                        style: TextStyle(
                          fontFamily: 'SofiaPro',
                          fontSize: 16,
                          color: Color(0xFF9796A1),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 40),

                      CustomTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hint: 'Your phone number',
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 80), 

                      Center(
                        child: PrimaryButton(
                          text: 'Send',
                          width: 250,
                          isLoading: _isLoading,
                          onPressed: _handleSend,
                        ),
                      ),

                      const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
