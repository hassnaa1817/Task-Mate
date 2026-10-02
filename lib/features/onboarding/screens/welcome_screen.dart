import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E7),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 700;
            final actionWidth = (constraints.maxWidth - 56)
                .clamp(0.0, 320.0)
                .toDouble();

            return Stack(
              children: [
                Positioned(
                  left: -42,
                  top: constraints.maxHeight * 0.13,
                  child: _DecorCircle(
                    size: 120,
                    color: const Color(0xFFE8C5C0).withValues(alpha: 0.75),
                  ),
                ),
                Positioned(
                  right: -42,
                  top: constraints.maxHeight * 0.2,
                  child: _DecorCircle(
                    size: 130,
                    color: const Color(0xFFE3F0F9).withValues(alpha: 0.8),
                  ),
                ),
                Positioned(
                  left: 26,
                  bottom: constraints.maxHeight * 0.11,
                  child: _DecorCircle(
                    size: 98,
                    color: const Color(0xFFCFE6D8).withValues(alpha: 0.8),
                  ),
                ),
                Positioned(
                  right: 24,
                  bottom: constraints.maxHeight * 0.08,
                  child: _DecorCircle(
                    size: 82,
                    color: const Color(0xFFE7D7F3).withValues(alpha: 0.6),
                  ),
                ),
                Positioned(
                  left: 60,
                  top: constraints.maxHeight * 0.18,
                  child: Transform.rotate(
                    angle: -0.65,
                    child: Container(
                      width: 48,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5B3A9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 66,
                  top: constraints.maxHeight * 0.16,
                  child: Transform.rotate(
                    angle: 0.55,
                    child: Container(
                      width: 26,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8A782),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            28,
                            compact ? 4 : 22,
                            28,
                            compact ? 8 : 28,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: compact ? 8 : 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF263D62),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Task Mate',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF263D62),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.6,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: compact ? 10 : 28),
                              Center(
                                child: Container(
                                  width: double.infinity,
                                  height: compact ? 230 : 220,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F7F7),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x140D1B2D),
                                        blurRadius: 18,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: compact ? 84 : 116,
                                        height: compact ? 84 : 116,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFCBDCF0),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF9ABAE0)
                                                  .withValues(alpha: 0.35),
                                              blurRadius: 24,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.school_rounded,
                                          size: compact ? 44 : 56,
                                          color: const Color(0xFF263D62),
                                        ),
                                      ),
                                      SizedBox(height: compact ? 8 : 18),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 26,
                                        ),
                                        child: Text(
                                          'Your calm corner for\nclasses, clubs &\ncampus life',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF2D425E),
                                            fontSize: 16,
                                            height: 1.35,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: compact ? 12 : 34),
                              Text(
                                'Meet Task Mate',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF263D62),
                                  fontSize: compact ? 32 : 40,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1.2,
                                ),
                              ),
                              SizedBox(height: compact ? 6 : 10),
                              const Text(
                                'Plan assignments, study sessions and campus\ncommitments without the overwhelm.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF65758F),
                                  fontSize: 15,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: compact ? 10 : 22),
                              SizedBox(
                                width: actionWidth,
                                height: 58,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute<void>(
                                        builder: (_) =>
                                            const OnboardingScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF263D62),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Get Started',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
