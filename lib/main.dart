import 'package:cookly/cookly.dart';
import 'package:cookly/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase with platform-specific options
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Hides status and navigation bars for a full-screen experience
  runApp(Cookly());
}
