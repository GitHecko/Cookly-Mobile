import 'package:cookly/core/theme/app_colors.dart';
import 'package:cookly/feature/auth/presentation/ui/login/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundCreamWarm,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.42,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/onboarding.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                "30K+ PREMIUM RECIPES",
                style: TextStyle(
                  color: AppColors.brandBlueDark,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: size.height * 0.06),
              const Text(
                "It's \nCooking Time!",
                style: TextStyle(
                  color: AppColors.brandBlueDark,
                  fontSize: 50.0,
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.09),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.brandCoralAlt2,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        height: 60,
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: const Center(
                          child: Text(
                            "Start Cooking!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
