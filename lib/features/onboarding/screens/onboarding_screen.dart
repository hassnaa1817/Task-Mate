import 'package:flutter/material.dart';

import 'onboarding_one_screen.dart';
import 'onboarding_three_screen.dart';
import 'onboarding_two_screen.dart';

import 'package:task_mate/features/auth/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<Widget> _pages = [
    OnboardingOneScreen(),
    OnboardingTwoScreen(),
    OnboardingThreeScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E7),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = (constraints.maxWidth / 390)
                .clamp(0.75, 1.0)
                .toDouble();
            final controlHeight = 58 * scale;
            final actionWidth = (constraints.maxWidth - 56)
                .clamp(0.0, 320.0)
                .toDouble();
            final controlAreaHeight = controlHeight + 30 * scale;

            return Stack(
              children: [
                Positioned(
                  left: -45,
                  top: constraints.maxHeight * 0.16,
                  child: _DecorCircle(
                    size: 150 * scale,
                    color: const Color(0xFFE8C5C0).withValues(alpha: 0.65),
                  ),
                ),
                Positioned(
                  right: -48,
                  top: constraints.maxHeight * 0.3,
                  child: _DecorCircle(
                    size: 165 * scale,
                    color: const Color(0xFFE3F0F9).withValues(alpha: 0.7),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: controlAreaHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: (_currentPage == index ? 18 : 8) * scale,
                            height: 8 * scale,
                            margin: EdgeInsets.symmetric(
                              horizontal: 5 * scale,
                            ),
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? const Color(0xFF7BA9D8)
                                  : const Color(0xFFB9C4CF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 14 * scale),
                      SizedBox(
                        width: actionWidth,
                        height: controlHeight,
                        child: ElevatedButton(
                          onPressed: _goToNextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF263D62),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8 * scale,
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isLastPage ? 'Let’s Begin' : 'Next',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18 * scale,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(width: 8 * scale),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 22 * scale,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8 * scale),
                    ],
                  ),
                ),
                Positioned.fill(
                  bottom: controlAreaHeight,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    children: _pages,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
