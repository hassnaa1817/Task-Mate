import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_mate/core/utils/date_utils.dart';

class DeadlineCountdown extends StatefulWidget {
  const DeadlineCountdown({
    super.key,
    required this.deadline,
    this.isCompleted = false,
    this.showOverdueBadge = false,
    this.fontSize = 10,
  });

  final DateTime deadline;
  final bool isCompleted;
  final bool showOverdueBadge;
  final double fontSize;

  @override
  State<DeadlineCountdown> createState() => _DeadlineCountdownState();
}

class _DeadlineCountdownState extends State<DeadlineCountdown> {
  static const _overdueColor = Color(0xFFE98B78);
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant DeadlineCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deadline != widget.deadline) {
      _refreshTimer?.cancel();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCompleted) {
      return Text(
        'Completed',
        style: TextStyle(
          color: const Color(0xFF85C3A1),
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    final overdue = TaskDateUtils.isOverdue(widget.deadline);
    final color = overdue ? _overdueColor : const Color(0xFF71809A);
    return Wrap(
      spacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (overdue && widget.showOverdueBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: _overdueColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'OVERDUE',
              style: TextStyle(
                color: _overdueColor,
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
        Text(
          TaskDateUtils.formatCountdown(widget.deadline),
          style: TextStyle(
            color: color,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
