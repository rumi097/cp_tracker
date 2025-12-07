import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/problem_tracker_provider.dart';
import '../services/quotes_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<ProblemTrackerProvider>();
    final todayCount = tracker.problemsSolvedToday();
    final streak = tracker.streak.currentStreak;
    final maxStreak = tracker.streak.maxStreak;
    final remaining = (tracker.streakThreshold - todayCount).clamp(0, tracker.streakThreshold);
    final quote = QuotesService().getDailyQuote();
    
    return RefreshIndicator(
      onRefresh: () async => tracker.load(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Motivational Quote Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1A237E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.format_quote, color: Colors.white70, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    quote,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Today's Progress Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: todayCount >= tracker.streakThreshold
                    ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]
                    : [const Color(0xFFB71C1C), const Color(0xFFC62828)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today\'s Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$todayCount / ${tracker.streakThreshold}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (todayCount / tracker.streakThreshold).clamp(0.0, 1.0),
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  remaining > 0
                      ? '🔥 Solve $remaining more to secure your streak!'
                      : '✨ Amazing! Streak secured for today!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Streak Stats Cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Current Streak',
                  value: streak.toString(),
                  icon: Icons.local_fire_department,
                  color: const Color(0xFFE65100),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Max Streak',
                  value: maxStreak.toString(),
                  icon: Icons.emoji_events,
                  color: const Color(0xFFF57F17),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/log'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Log Solved Problem', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 12),
          
          ElevatedButton.icon(
            onPressed: tracker.isAutoSyncing ? null : () async {
              await tracker.syncFromPlatforms();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Synced ${tracker.problemsSolvedToday()} problems today!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
            ),
            icon: tracker.isAutoSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.sync, color: Colors.white),
            label: Text(
              tracker.isAutoSyncing ? 'Syncing...' : 'Sync Now',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          
          Text('Recent Problems', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...tracker.logs.reversed.take(10).map((l) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF1A237E).withValues(alpha: 0.15),
                    child: const Icon(Icons.code, color: Color(0xFF1A237E)),
                  ),
                  title: Text(l.platform + (l.problemId != null ? ' - ${l.problemId}' : '')),
                  subtitle: Text('${l.difficulty} • ${l.timestamp.hour.toString().padLeft(2, '0')}:${l.timestamp.minute.toString().padLeft(2, '0')}'),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              )),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
