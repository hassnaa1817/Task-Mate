import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const _navy = Color(0xFF263D62);
  static const _cream = Color(0xFFF6F3E8);

  @override
  Widget build(BuildContext context) {
    const labels = ['Home', 'Tasks', 'Add', 'Calendar', 'Profile'];
    const icons = [
      Icons.home_outlined,
      Icons.checklist_rounded,
      Icons.add,
      Icons.calendar_month_outlined,
      Icons.person_outline,
    ];

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x240F1C2E),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(labels.length, (index) {
          final isAdd = index == 2;
          final selected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 43,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAdd)
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF73A9D6),
                        shape: BoxShape.circle,
                        border: Border.all(color: _cream, width: 4),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  else ...[
                    Icon(
                      icons[index],
                      color: selected ? const Color(0xFF83B9E6) : Colors.white,
                      size: 20,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      labels[index],
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFF83B9E6)
                            : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
