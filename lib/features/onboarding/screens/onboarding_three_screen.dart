import 'package:flutter/material.dart';

import 'onboarding_page_content.dart';

class OnboardingThreeScreen extends StatelessWidget {
  const OnboardingThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingPageContent(
      illustrationIcon: Icons.bar_chart_rounded,
      illustrationColor: Color(0xFFDBE9DA),
      decorationColor: Color(0xFFEED4B1),
      kicker: 'Watch small wins\nadd up',
      title: 'See your progress',
      description:
          'Celebrate completed tasks and build\nmomentum through every semester.',
    );
  }
}
