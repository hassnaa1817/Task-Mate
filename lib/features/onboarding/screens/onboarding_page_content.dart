import 'package:flutter/material.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    required this.illustrationIcon,
    required this.illustrationColor,
    required this.decorationColor,
    required this.kicker,
    required this.title,
    required this.description,
    super.key,
  });

  final IconData illustrationIcon;
  final Color illustrationColor;
  final Color decorationColor;
  final String kicker;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final circleSize = (constraints.maxWidth * 0.3)
            .clamp(90.0, 120.0)
            .toDouble();

        return Stack(
          children: [
            Positioned(
              left: 18,
              top: constraints.maxHeight * 0.2,
              child: _DecorCircle(
                size: circleSize,
                color: decorationColor.withValues(alpha: 0.7),
              ),
            ),
            Positioned(
              right: 18,
              top: constraints.maxHeight * 0.25,
              child: _DecorCircle(
                size: circleSize,
                color: const Color(0xFFE9DDE2).withValues(alpha: 0.65),
              ),
            ),
            Positioned(
              left: 64,
              top: constraints.maxHeight * 0.28,
              child: Transform.rotate(
                angle: -0.65,
                child: Container(
                  width: 38,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEAA7F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 62,
              top: constraints.maxHeight * 0.23,
              child: Transform.rotate(
                angle: 0.65,
                child: Container(
                  width: 26,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1B89C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 14,
              right: 20,
              child: Text(
                'Skip',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1F3554),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned.fill(
              top: 48,
              child: LayoutBuilder(
                builder: (context, contentConstraints) {
                  final illustrationHeight = (contentConstraints.maxHeight *
                          0.36)
                      .clamp(150.0, 220.0)
                      .toDouble();
                  final iconSize = (illustrationHeight * 0.54)
                      .clamp(76.0, 124.0)
                      .toDouble();

                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: contentConstraints.maxHeight,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: illustrationHeight,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF1F2),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x140D1B2D),
                                        blurRadius: 16,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: iconSize,
                                      height: iconSize,
                                      decoration: BoxDecoration(
                                        color: illustrationColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: illustrationColor.withValues(
                                              alpha: 0.35,
                                            ),
                                            blurRadius: 18,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        illustrationIcon,
                                        size: iconSize * 0.52,
                                        color: const Color(0xFF2A446A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              Text(
                                kicker,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF263D62),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF263D62),
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                  letterSpacing: -1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF6C7D94),
                                  fontSize: 15,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
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
