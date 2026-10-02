import 'package:flutter/material.dart';

import 'onboarding_page_content.dart';

class OnboardingTwoScreen extends StatelessWidget {
  const OnboardingTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingPageContent(
      illustrationIcon: Icons.calendar_month_rounded,
      illustrationColor: Color(0xFFE9D9CF),
      decorationColor: Color(0xFFE8D8C1),
      kicker: 'Friendly nudges,\nright on time',
      title: 'Never miss a\ndeadline',
      description:
          'Smart reminders give you time to focus, submit\nand still make it to dinner.',
    );
  }
}
