import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/problem_tracker_provider.dart';

class LogProblemScreen extends StatefulWidget {
  const LogProblemScreen({super.key});

  @override
  State<LogProblemScreen> createState() => _LogProblemScreenState();
}

class _LogProblemScreenState extends State<LogProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  String platform = 'Codeforces';
  String difficulty = 'Unrated';
  String? problemId;

  @override
  Widget build(BuildContext context) {
    final tracker = context.read<ProblemTrackerProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Log Problem')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: platform,
                items: const [
                  'Codeforces','LeetCode','CodeChef','AtCoder','GeeksforGeeks','CodingNinjas'
                ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => platform = v!),
                decoration: const InputDecoration(labelText: 'Platform'),
              ),
              DropdownButtonFormField<String>(
                initialValue: difficulty,
                items: const ['Easy','Medium','Hard','Unrated']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => difficulty = v!),
                decoration: const InputDecoration(labelText: 'Difficulty'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Problem ID / Name (optional)'),
                onChanged: (v) => problemId = v.trim().isEmpty ? null : v.trim(),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  tracker.logProblem(platform: platform, difficulty: difficulty, problemId: problemId);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
