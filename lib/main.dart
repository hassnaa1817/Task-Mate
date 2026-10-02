import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/onboarding/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initialScreen});

  final Widget? initialScreen;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Mate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF263D62)),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: initialScreen ?? const SplashScreen(),
    );
  }
}
