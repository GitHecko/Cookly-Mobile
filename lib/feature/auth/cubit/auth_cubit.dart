import 'package:cookly/feature/auth/cubit/auth_state.dart';
import 'package:cookly/feature/auth/data/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // LOGIN WITH EMAIL
  login({required String emailAddress, required String password}) async {
    emit(AuthLoading());

    try {
      final response = await AuthRepo.loginWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
      );

      if (response.user != null) {
        emit(AuthSuccess());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Login failed"));
    } catch (e) {
      emit(AuthError("Something went wrong"));
    }
  }

  // REGISTER
  register({
    required String emailAddress,
    required String password,
    String? displayName,
  }) async {
    emit(AuthLoading());

    try {
      final response = await AuthRepo.registerWithEmailAndPassword(
        emailAddress: emailAddress,
        password: password,
        displayName: displayName,
      );

      if (response.user != null) {
        emit(AuthSuccess());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Register failed"));
    } catch (e) {
      emit(AuthError("Something went wrong"));
    }
  }

  // GOOGLE LOGIN
  loginWithGoogle() async {
    emit(AuthLoading());

    try {
      final response = await AuthRepo.signInWithGoogle();

      if (response.user != null) {
        emit(AuthSuccess());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Google sign in failed"));
    } catch (e) {
      emit(AuthError("Something went wrong"));
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    emit(AuthInitial()); // Reset state so the app redirects to Login
  }

  // Reset Password
  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      // Attempt to send the reset email directly
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(AuthResetEmailSent());
    } on FirebaseAuthException catch (e) {
      // If Email Enumeration Protection is OFF in Firebase Console, throw 'user-not-found'
      if (e.code == 'user-not-found') {
        emit(AuthError("This email is not registered. Please sign up first."));
      } else {
        emit(AuthError(e.message ?? "An error occurred"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
