import 'package:flutter/material.dart';
import 'package:task_mate/core/services/storage_service.dart';
import 'package:task_mate/features/calendar/screens/calendar_screen.dart';
import 'package:task_mate/features/home/screens/home_screen.dart';
import 'package:task_mate/features/tasks/screens/add_task_screen.dart';
import 'package:task_mate/features/tasks/screens/task_list_screen.dart';
import 'package:task_mate/shared/widgets/bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _navy = Color(0xFF263D62);
  static const _cream = Color(0xFFF6F3E8);
  static const _muted = Color(0xFF71809A);
  static const _blue = Color(0xFF73A9D6);
  static const _green = Color(0xFF85C3A1);
  static const _coral = Color(0xFFEF806D);
  static const _card = Colors.white;

  String get _name => AuthStorage.instance.currentUser?.name ?? 'Guest';
  String get _email => AuthStorage.instance.currentUser?.email ?? '';

  static String _course = 'BSc Psychology · Year 2';
  static bool _taskReminders = true;
  static bool _weeklyEncouragement = true;
  static bool _groupUpdates = false;
  static bool _weekStartsMonday = true;
  static String _appearance = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 13),
              _buildProfileCard(),
              const SizedBox(height: 13),
              const Text(
                'Notification settings',
                style: TextStyle(
                  color: _navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 9),
              _buildNotificationCard(),
              const SizedBox(height: 11),
              const Text(
                'App settings',
                style: TextStyle(
                  color: _navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 9),
              _buildAppSettings(),
              const SizedBox(height: 12),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        child: BottomNavigation(selectedIndex: 4, onTap: _handleNavigation),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  color: _navy,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Your Task Mate space',
                style: TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: _card,
          shape: const CircleBorder(),
          child: IconButton(
            tooltip: 'Settings',
            onPressed: _openStudyWeekSettings,
            icon: const Icon(Icons.settings_outlined, color: _navy, size: 18),
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    final initials = _name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(19),
        boxShadow: const [
          BoxShadow(
            color: Color(0x130F1C2E),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFDDECF6),
              shape: BoxShape.circle,
            ),
            child: Text(
              initials.isEmpty ? 'U' : initials,
              style: const TextStyle(
                color: _navy,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (_email.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    _email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _muted, fontSize: 9),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _course,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 9),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F2E8),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Text(
                    '12 DAY STREAK',
                    style: TextStyle(
                      color: _green,
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit profile',
            onPressed: _editProfile,
            icon: const Icon(Icons.edit_outlined, color: _blue, size: 17),
            constraints: const BoxConstraints.tightFor(width: 34, height: 34),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _notificationRow(
            icon: Icons.notifications_active_outlined,
            title: 'Task reminders',
            subtitle: 'Deadlines and study sessions',
            value: _taskReminders,
            onChanged: (value) => setState(() => _taskReminders = value),
          ),
          _notificationRow(
            icon: Icons.auto_awesome_outlined,
            title: 'Weekly encouragement',
            subtitle: 'A Sunday progress recap',
            value: _weeklyEncouragement,
            onChanged: (value) => setState(() => _weeklyEncouragement = value),
          ),
          _notificationRow(
            icon: Icons.groups_outlined,
            title: 'Group task updates',
            subtitle: 'Changes from classmates',
            value: _groupUpdates,
            onChanged: (value) => setState(() => _groupUpdates = value),
          ),
        ],
      ),
    );
  }

  Widget _notificationRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 49,
      child: Row(
        children: [
          Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
              color: const Color(0xFFE1EFF8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _blue, size: 16),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: _muted, fontSize: 8),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.82,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: _green,
              inactiveTrackColor: const Color(0xFFDCDAD1),
              inactiveThumbColor: Colors.white,
              trackOutlineColor: const WidgetStatePropertyAll(
                Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          _settingsRow(
            icon: Icons.access_time,
            title: 'Study week starts',
            value: _weekStartsMonday ? 'Monday' : 'Sunday',
            onTap: _openStudyWeekSettings,
          ),
          const Divider(height: 1, indent: 12, endIndent: 12),
          _settingsRow(
            icon: Icons.dark_mode_outlined,
            title: 'Appearance',
            value: _appearance,
            onTap: _openAppearanceSettings,
          ),
          const Divider(height: 1, indent: 12, endIndent: 12),
          _settingsRow(
            icon: Icons.help_outline_rounded,
            title: 'Help & feedback',
            onTap: _showHelp,
          ),
        ],
      ),
    );
  }

  Widget _settingsRow({
    required IconData icon,
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(icon, color: _blue, size: 15),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (value != null)
                  Text(
                    value,
                    style: const TextStyle(color: _muted, fontSize: 8),
                  ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: _muted,
                  size: 17,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: FilledButton.icon(
        onPressed: _confirmLogout,
        icon: const Icon(Icons.logout_rounded, size: 15),
        label: const Text(
          'Log out',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFF9E1DC),
          foregroundColor: _coral,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }

  Future<void> _editProfile() async {
    var name = _name;
    var course = _course;
    var error = '';
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                initialValue: _course,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Study program'),
                onChanged: (value) => course = value,
              ),
              if (error.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      error,
                      style: const TextStyle(color: _coral, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (name.trim().isEmpty) {
                  setDialogState(() => error = 'Name cannot be empty.');
                  return;
                }
                Navigator.pop(dialogContext, (name.trim(), course.trim()));
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (result == null || !mounted) return;
    if (!AuthStorage.instance.updateCurrentUserName(name: result.$1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update the account name.')),
      );
      return;
    }
    setState(() {
      _course = result.$2;
    });
  }

  Future<void> _openStudyWeekSettings() async {
    final monday = await showDialog<bool>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Study week starts'),
        children: [
          ListTile(
            title: const Text('Monday'),
            trailing: _weekStartsMonday
                ? const Icon(Icons.check, color: _blue)
                : null,
            onTap: () => Navigator.pop(context, true),
          ),
          ListTile(
            title: const Text('Sunday'),
            trailing: !_weekStartsMonday
                ? const Icon(Icons.check, color: _blue)
                : null,
            onTap: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
    if (monday == null || !mounted) return;
    setState(() => _weekStartsMonday = monday);
  }

  Future<void> _openAppearanceSettings() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Appearance'),
        children: [
          ListTile(
            title: const Text('Light'),
            trailing: _appearance == 'Light'
                ? const Icon(Icons.check, color: _blue)
                : null,
            onTap: () => Navigator.pop(context, 'Light'),
          ),
          ListTile(
            title: const Text('Dark'),
            trailing: _appearance == 'Dark'
                ? const Icon(Icons.check, color: _blue)
                : null,
            onTap: () => Navigator.pop(context, 'Dark'),
          ),
        ],
      ),
    );
    if (selected == null || !mounted) return;
    setState(() => _appearance = selected);
  }

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & feedback'),
        content: const Text(
          'Need a hand with Task Mate? Share feedback or report an issue to '
          'your app administrator.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'Account sign-out is not connected in this version of Task Mate.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (shouldLogout == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account sign-out is not available yet.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleNavigation(int index) {
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const TaskListScreen()),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AddTaskScreen()),
      );
    } else if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const CalendarScreen()),
      );
    }
  }
}
