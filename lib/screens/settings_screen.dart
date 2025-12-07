import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../providers/problem_tracker_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _codeforcesController = TextEditingController();
  final _leetcodeController = TextEditingController();
  final _codechefController = TextEditingController();
  final _atcoderController = TextEditingController();
  bool _editingUsernames = false;
  
  // Store original values for cancel functionality
  String _originalCF = '';
  String _originalLC = '';
  String _originalCC = '';
  String _originalAC = '';
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tracker = context.read<ProblemTrackerProvider>();
      _codeforcesController.text = tracker.usernames['Codeforces'] ?? '';
      _leetcodeController.text = tracker.usernames['LeetCode'] ?? '';
      _codechefController.text = tracker.usernames['CodeChef'] ?? '';
      _atcoderController.text = tracker.usernames['AtCoder'] ?? '';
      
      // Store original values
      _originalCF = _codeforcesController.text;
      _originalLC = _leetcodeController.text;
      _originalCC = _codechefController.text;
      _originalAC = _atcoderController.text;
    });
  }

  @override
  void dispose() {
    _codeforcesController.dispose();
    _leetcodeController.dispose();
    _codechefController.dispose();
    _atcoderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notif = context.watch<NotificationProvider>();
    final tracker = context.watch<ProblemTrackerProvider>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Platform Usernames Section
          _buildSectionHeader(context, 'Platform Usernames'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter your usernames to enable automatic problem syncing',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  _buildUsernameField('Codeforces', _codeforcesController, Icons.code),
                  const SizedBox(height: 12),
                  _buildUsernameField('LeetCode', _leetcodeController, Icons.lightbulb_outline),
                  const SizedBox(height: 12),
                  _buildUsernameField('CodeChef', _codechefController, Icons.restaurant),
                  const SizedBox(height: 12),
                  _buildUsernameField('AtCoder', _atcoderController, Icons.flag),
                  const SizedBox(height: 16),
                  if (!_editingUsernames)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _editingUsernames = true;
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Usernames'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: tracker.isAutoSyncing ? null : () => _syncNow(tracker),
                            icon: tracker.isAutoSyncing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.sync),
                            label: Text(tracker.isAutoSyncing ? 'Syncing...' : 'Sync Now'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                // Restore original values
                                _codeforcesController.text = _originalCF;
                                _leetcodeController.text = _originalLC;
                                _codechefController.text = _originalCC;
                                _atcoderController.text = _originalAC;
                                _editingUsernames = false;
                              });
                            },
                            icon: const Icon(Icons.cancel),
                            label: const Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _saveUsernames(tracker),
                            icon: const Icon(Icons.save),
                            label: const Text('Save'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sync fetches today\'s accepted submissions from platform APIs',
                    style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 24),

          // Streak Settings
          _buildSectionHeader(context, 'Streak Settings'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.local_fire_department, color: Colors.orange),
                  title: const Text('Daily Problem Threshold'),
                  subtitle: Text('Solve at least ${tracker.streakThreshold} problems/day to maintain streak'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: tracker.streakThreshold > 1
                            ? () => tracker.updateStreakThreshold(tracker.streakThreshold - 1)
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${tracker.streakThreshold}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: tracker.streakThreshold < 10
                            ? () => tracker.updateStreakThreshold(tracker.streakThreshold + 1)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 24),
          
          // Notifications Section
          _buildSectionHeader(context, 'Notifications'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: Text(notif.initialized 
                      ? 'Notifications are active' 
                      : 'Turn on to receive reminders'),
                  value: notif.initialized,
                  onChanged: (v) async {
                    if (v) {
                      await notif.enableNotifications();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notifications enabled!')),
                        );
                      }
                    } else {
                      await notif.disableNotifications();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notifications disabled')),
                        );
                      }
                    }
                  },
                ),
                if (notif.initialized) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Notification Times',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextButton.icon(
                              onPressed: () => _showAddTimeDialog(context, notif),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add Time'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (notif.notificationTimes.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                'No notification times set',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: notif.notificationTimes.map((time) {
                              return Chip(
                                label: Text(time),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () => notif.removeNotificationTime(time),
                                backgroundColor: const Color(0xFF1A237E).withValues(alpha: 0.1),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 8),
                        const Text(
                          'Times are in Bangladesh timezone (Asia/Dhaka)',
                          style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 24),

          // Statistics Cards
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.bar_chart, color: Color(0xFF1A237E)),
              title: const Text('View Statistics'),
              subtitle: const Text('See your progress breakdown'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.of(context).pushNamed('/statistics'),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.pie_chart, color: Color(0xFF1A237E)),
              title: const Text('Platform Statistics'),
              subtitle: const Text('See platform-wise problem count'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.of(context).pushNamed('/platform-statistics'),
            ),
          ),
          
          const Divider(height: 24),
          
          // About Section
          _buildSectionHeader(context, 'About'),
          const Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('CP Tracker'),
              subtitle: Text('Version 1.0.0\nYour competitive programming companion\nConfigured for Bangladesh Time (Asia/Dhaka)'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A237E),
        ),
      ),
    );
  }

  Widget _buildUsernameField(String platform, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      enabled: _editingUsernames,
      decoration: InputDecoration(
        labelText: platform,
        hintText: 'Enter your $platform username',
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: _editingUsernames ? Colors.grey[50] : Colors.grey[200],
      ),
    );
  }

  void _saveUsernames(ProblemTrackerProvider tracker) {
    final usernames = {
      'Codeforces': _codeforcesController.text.trim(),
      'LeetCode': _leetcodeController.text.trim(),
      'CodeChef': _codechefController.text.trim(),
      'AtCoder': _atcoderController.text.trim(),
    };
    
    tracker.updateUsernames(usernames);
    
    // Update original values after saving
    setState(() {
      _originalCF = _codeforcesController.text;
      _originalLC = _leetcodeController.text;
      _originalCC = _codechefController.text;
      _originalAC = _atcoderController.text;
      _editingUsernames = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usernames saved! Tap "Sync Now" to fetch submissions.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _syncNow(ProblemTrackerProvider tracker) async {
    await tracker.syncFromPlatforms();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Synced ${tracker.problemsSolvedToday()} problems today!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAddTimeDialog(BuildContext context, NotificationProvider notif) {
    TimeOfDay selectedTime = TimeOfDay.now();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Notification Time'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select time for daily notification:'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setState(() => selectedTime = time);
                    }
                  },
                  child: Text(
                    '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final timeStr = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
              notif.addNotificationTime(timeStr);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added notification at $timeStr')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
