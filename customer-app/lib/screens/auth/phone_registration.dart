import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class PhoneRegistration extends StatelessWidget {
  const PhoneRegistration({super.key});

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

                      const CustomTextField(
                        label: 'Phone Number',
                        hint: 'Your phone number',
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 80), 

                      Center(
                        child: PrimaryButton(
                          text: 'Send',
                          width: 250,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Send')),
                            );
                            Navigator.pop(context);
                          },
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
}
