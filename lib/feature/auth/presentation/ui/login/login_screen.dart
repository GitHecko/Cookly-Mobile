import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/core/widgets/TextField.dart';
import 'package:cookly/core/widgets/show_forget_password_dialog.dart';
import 'package:cookly/core/widgets/show_loading_dialog.dart';
import 'package:cookly/feature/auth/cubit/auth_cubit.dart';
import 'package:cookly/feature/auth/cubit/auth_state.dart';
import 'package:cookly/feature/auth/presentation/ui/register/register_screen.dart';
import 'package:cookly/feature/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //To prevent crash when popping loading dialog on error/success
  void _closeLoadingDialog() {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCreamAlt,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Dark Blue Top Circle
          Positioned(
            top: -50,
            left: -50,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: AppColors.brandBlue,
            ),
          ),
          // Coral Bottom Circle
          Positioned(
            bottom: -200,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: AppColors.brandCoralAlt,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Welcome\nBack!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 80),

                  // Email Input
                  Textfield(
                    controller: emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),

                  // Password Input
                  Textfield(
                    controller: passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    icon: Icons.lock,
                    isPassword: true,
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        showForgotPasswordDialog(context);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppColors.brandBlue),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Auth Action Row (Arrow Button)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocListener<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthLoading) {
                            showLoadingDialog(context);
                          } else if (state is AuthSuccess) {
                            _closeLoadingDialog();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          } else if (state is AuthResetEmailSent) {
                            _closeLoadingDialog(); // Close the loading spinner
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Success! Please check your inbox for the reset link.",
                                ),
                                backgroundColor: AppColors.brandBlue,
                                behavior: SnackBarBehavior.floating,
                                dismissDirection: DismissDirection.vertical,
                                showCloseIcon: true,
                              ),
                            );
                          } else if (state is AuthError) {
                            _closeLoadingDialog();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                behavior: SnackBarBehavior.floating,
                                dismissDirection: DismissDirection.vertical,
                                showCloseIcon: true,
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.brandCoralAlt,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              context.read<AuthCubit>().login(
                                emailAddress: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Google Sign In Button
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          context.read<AuthCubit>().loginWithGoogle(),
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(240, 50),
                        side: const BorderSide(
                          color: AppColors.brandBlue,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(
                        Icons.g_mobiledata,
                        size: 35,
                        color: AppColors.brandBlue,
                      ),
                      label: const Text(
                        "Sign in with Google",
                        style: TextStyle(
                          color: AppColors.brandBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Navigation to Sign Up
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                color: AppColors.brandBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
