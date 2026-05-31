import 'package:cookly/feature/auth/cubit/auth_cubit.dart';
import 'package:cookly/feature/auth/presentation/ui/login/login_screen.dart';
import 'package:cookly/feature/home/presentation/home_screen.dart';
import 'package:cookly/feature/welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Cookly extends StatelessWidget {
  const Cookly({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cookly',
        theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance
              .authStateChanges(), // Listen to authentication state changes
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final user = snapshot.data;
            if (user != null) {
              // User is authenticated, show HomeScreen
              return const HomeScreen();
            }

            return const WelcomeScreen();
          },
        ),
        // Define Named Routes for navigation
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
