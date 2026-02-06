import 'package:flutter/material.dart';
import '../services/auth_service.dart';

mixin SocialAuthMixin<T extends StatefulWidget> on State<T> {
  final AuthService _authService = AuthService();
  bool isSocialLoading = false;

  Future<void> handleGoogleSignIn({
    required VoidCallback onSuccess,
    VoidCallback? onCancel,
  }) async {
    if (isSocialLoading) return;

    setState(() => isSocialLoading = true);
    try {
      final response = await _authService.signInWithGoogle();
      if (!mounted) return;

      if (response.success) {
        onSuccess();
      } else if (response.code == 401) {
        onCancel?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } finally {
      if (mounted) setState(() => isSocialLoading = false);
    }
  }

  Future<void> handleFacebookSignIn({
    required VoidCallback onSuccess,
    VoidCallback? onCancel,
  }) async {
    if (isSocialLoading) return;

    setState(() => isSocialLoading = true);
    try {
      final response = await _authService.signInWithFacebook();
      if (!mounted) return;

      if (response.success) {
        onSuccess();
      } else if (response.code == 401) {
        onCancel?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } finally {
      if (mounted) setState(() => isSocialLoading = false);
    }
  }
}
