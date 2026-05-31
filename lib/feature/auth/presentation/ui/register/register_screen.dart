import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/core/widgets/TextField.dart';
import 'package:cookly/core/widgets/show_loading_dialog.dart';
import 'package:cookly/feature/auth/cubit/auth_cubit.dart';
import 'package:cookly/feature/auth/cubit/auth_state.dart';
import 'package:cookly/feature/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Helper function to safely close the loading dialog
  void _closeLoadingDialog() {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCreamAlt, // Matches Login Theme
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
                    'Create An\nAccount!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 80),

                  // Name Input
                  Textfield(
                    controller: nameController,
                    label: 'Name',
                    hint: 'Enter your name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),

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

                  const SizedBox(height: 40),

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
                          } else if (state is AuthError) {
                            _closeLoadingDialog();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                dismissDirection: DismissDirection.vertical,
                                showCloseIcon: true,
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.brandCoralAlt, // Coral
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              context.read<AuthCubit>().register(
                                emailAddress: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                displayName: nameController.text.trim(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Navigation back to Login
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Go back to Login Screen
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: AppColors.brandBlue, // Dark Blue
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
