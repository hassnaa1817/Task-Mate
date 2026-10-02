import 'package:flutter/material.dart';

import 'onboarding_page_content.dart';

class OnboardingOneScreen extends StatelessWidget {
  const OnboardingOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingPageContent(
      illustrationIcon: Icons.check_box_outlined,
      illustrationColor: Color(0xFFCEDDF3),
      decorationColor: Color(0xFFDCEFF6),
      kicker: 'One tidy place for\nevery class',
      title: 'Keep tasks\norganized',
      description:
          'Group coursework by module, priority and due\ndate so your week always feels clear.',
    );
  }
}
