import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/problem_tracker_provider.dart';
import 'providers/contest_provider.dart';
import 'providers/notification_provider.dart';
import 'services/storage_service.dart';
import 'services/contest_service.dart';
import 'services/notification_service.dart';
import 'services/submission_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/log_problem_screen.dart';
import 'screens/contests_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/platform_statistics_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CPTrackerApp());
}

class CPTrackerApp extends StatelessWidget {
  const CPTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    // Production backend deployed on Vercel
    const backendUrl = 'https://cpteacker-biibp58f8-ali-azgor-rumis-projects.vercel.app';
    final contestService = ContestService(baseUrl: '$backendUrl/contest');
    final submissionService = SubmissionService(baseUrl: backendUrl);
    final notificationService = NotificationService();
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProblemTrackerProvider(storage, submissionService)..load()),
        ChangeNotifierProvider(create: (_) => ContestProvider(contestService)..refresh()),
        ChangeNotifierProvider(create: (_) => NotificationProvider(notificationService, storage)..init()),
      ],
      child: MaterialApp(
        title: 'CP Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A237E), // Dark indigo
            brightness: Brightness.light,
            primary: const Color(0xFF1A237E),
            secondary: const Color(0xFF0D47A1),
            surface: const Color(0xFFF5F5F5),
          ),
          scaffoldBackgroundColor: const Color(0xFFECEFF1),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A237E),
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          cardTheme: const CardThemeData(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
          useMaterial3: true,
        ),
        routes: {
          '/': (_) => const HomeShell(),
          '/log': (_) => const LogProblemScreen(),
          '/contests': (_) => const ContestsScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/statistics': (_) => const StatisticsScreen(),
          '/platform-statistics': (_) => const PlatformStatisticsScreen(),
        },
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final _screens = const [DashboardScreen(), ContestsScreen(), SettingsScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CP Tracker')),
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.event), label: 'Contests'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).pushNamed('/log'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
