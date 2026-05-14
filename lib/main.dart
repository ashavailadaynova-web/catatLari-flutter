import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/run_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart'; // Import Profile ViewModel
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/main_viewmodel.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RunViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => MainViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
