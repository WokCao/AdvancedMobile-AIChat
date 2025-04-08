import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/token_storage.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/custom_text_field.dart';
import '../../widgets/auth/divider_with_text.dart';
import '../../widgets/auth/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Handle login
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      setState(() {
        _isLoading = true;
      });

      final success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        final user = authProvider.user;
        if (user == null) {
          return;
        }

        await saveTokens(user.accessToken, user.refreshToken);
        Navigator.pushNamed(context, '/home');
      } else {
        // Show error returned from the server
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? 'Signup failed. Please try again')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width > 1024 ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.6,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  const AuthHeader(
                    title: 'Welcome back',
                    subtitle: 'Sign in to your account',
                    icon: FontAwesomeIcons.bots
                  ),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email field
                        CustomTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            // if (value == null || value.isEmpty) {
                            //   return 'Please enter your email';
                            // }
                            // if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            //   return 'Please enter a valid email';
                            // }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        CustomTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            // if (value == null || value.isEmpty) {
                            //   return 'Please enter your password';
                            // }
                            // if (value.length < 6) {
                            //   return 'Password must be at least 6 characters';
                            // }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submitForm(),
                        ),
                        const SizedBox(height: 16),

                        // Remember me
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Text('Remember me'),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                // Forgot password action
                              },
                              child: const Text('Forgot password?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Login button
                        AuthButton(
                          text: _isLoading ? 'Logging in...' : 'Sign In',
                          onPressed: _submitForm,
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Or continue with
                  const DividerWithText(text: 'Or continue with'),
                  const SizedBox(height: 24),

                  // Social login buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialLoginButton(
                        icon: Icons.g_mobiledata_rounded,
                        onPressed: () {
                          // Google login
                        },
                        tooltipMessage: 'Login with Google',
                        iconColor: Colors.red,
                      ),
                      const SizedBox(width: 16),
                      SocialLoginButton(
                        icon: Icons.facebook_rounded,
                        onPressed: () {
                          // Facebook login
                        },
                        tooltipMessage: 'Login with Facebook',
                        iconColor: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Sign up option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}