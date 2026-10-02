import 'dart:async';

import 'package:flutter/material.dart';

import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color _navy = Color(0xFF263D62);
  static const Color _cream = Color(0xFFF5F1E7);
  static const Color _lightBlue = Color(0xFF73A9D6);
  static const Color _green = Color(0xFF85C3A1);

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const WelcomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: _cream,
      body: Stack(
        children: [
          Positioned(
            left: -size.width * 0.1,
            top: size.height * 0.08,
            child: _DecorCircle(
              size: size.width * 0.45,
              color: _lightBlue.withOpacity(0.2),
            ),
          ),
          Positioned(
            right: -size.width * 0.12,
            bottom: size.height * 0.12,
            child: _DecorCircle(
              size: size.width * 0.52,
              color: _green.withOpacity(0.22),
            ),
          ),
          Positioned(
            left: size.width * 0.2,
            bottom: size.height * 0.18,
            child: _DecorCircle(
              size: size.width * 0.2,
              color: const Color(0xFFB9D7F4).withOpacity(0.35),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 136,
                  height: 136,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF345C8B), Color(0xFF263D62)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _navy.withOpacity(0.18),
                        blurRadius: 26,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Task Mate',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.2,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    'Stay on top of every task and make progress every day.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF637A96),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
