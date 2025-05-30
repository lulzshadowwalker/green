import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:green/provider/auth.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    // Branding colors
    final accent = const Color(0xFF2E8B57); // Green
    final secondary = const Color(0xFFF3F7F4); // Very light greenish
    final cardBg = Colors.white;

    final isAuthenticated = ref.watch(authStateProvider);

    OutlineInputBorder border({Color? color}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color ?? Colors.grey.shade300, width: 1.5),
    );

    // If authenticated, navigate to home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });

    return Scaffold(
      backgroundColor: secondary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo or icon
              CircleAvatar(
                radius: 36,
                backgroundColor: accent.withOpacity(0.08),
                child: Icon(Icons.eco, color: accent, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Green',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
              const SizedBox(height: 32),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 15),
                  ),
                ),
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person, color: accent),
                          filled: true,
                          fillColor: secondary,
                          border: border(),
                          enabledBorder: border(),
                          focusedBorder: border(color: accent),
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                        ),
                        onChanged: (v) => _username = v,
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Enter your username'
                                    : null,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: accent),
                          filled: true,
                          fillColor: secondary,
                          border: border(),
                          enabledBorder: border(),
                          focusedBorder: border(color: accent),
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed:
                                () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        onChanged: (v) => _password = v,
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Enter your password'
                                    : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed:
                              _loading
                                  ? null
                                  : () async {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      setState(() {
                                        _loading = true;
                                        _error = null;
                                      });
                                      try {
                                        await ref
                                            .read(authStateProvider.notifier)
                                            .login(_username, _password);
                                        // Navigation is handled by auth state listener above
                                      } catch (e) {
                                        log(e.toString());
                                        setState(() {
                                          _error =
                                              'Invalid username or password';
                                        });
                                      } finally {
                                        setState(() => _loading = false);
                                      }
                                    }
                                  },
                          child:
                              _loading
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
