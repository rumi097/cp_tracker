import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contest_provider.dart';
import '../models/contest.dart';
import 'package:intl/intl.dart';

class ContestsScreen extends StatefulWidget {
  const ContestsScreen({super.key});

  @override
  State<ContestsScreen> createState() => _ContestsScreenState();
}

class _ContestsScreenState extends State<ContestsScreen> {
  String _timeFilter = 'All';
  String? _platformFilter;

  List<Contest> _filterContests(List<Contest> contests) {
    // First filter by platform
    var filtered = contests;
    if (_platformFilter != null) {
      filtered = filtered.where((c) => c.platform == _platformFilter).toList();
    }
    
    // Then filter by time
    final now = DateTime.now();
    final next24hrs = now.add(const Duration(hours: 24));
    final next7days = now.add(const Duration(days: 7));

    switch (_timeFilter) {
      case 'Ongoing':
        return filtered.where((contest) {
          return contest.startTime.isBefore(now) && contest.endTime.isAfter(now);
        }).toList();
      case 'In next 24hrs':
        return filtered.where((contest) {
          return contest.startTime.isAfter(now) && contest.startTime.isBefore(next24hrs);
        }).toList();
      case 'In next 7days':
        return filtered.where((contest) {
          return contest.startTime.isAfter(now) && contest.startTime.isBefore(next7days);
        }).toList();
      default:
        return filtered;
    }
  }
  
  List<String> _getAvailablePlatforms(List<Contest> contests) {
    final platforms = contests.map((c) => c.platform).toSet().toList();
    platforms.sort();
    return platforms;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContestProvider>();
    final availablePlatforms = _getAvailablePlatforms(provider.contests);
    final filteredContests = _filterContests(provider.contests);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Contests'),
        actions: [
          if (availablePlatforms.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: DropdownButton<String>(
                value: _platformFilter,
                hint: const Text('All Platforms', style: TextStyle(color: Colors.white70)),
                dropdownColor: const Color(0xFF1A237E),
                icon: const Icon(Icons.filter_list, color: Colors.white),
                underline: Container(),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Platforms', style: TextStyle(color: Colors.white)),
                  ),
                  ...availablePlatforms.map((platform) {
                    return DropdownMenuItem<String>(
                      value: platform,
                      child: Text(platform, style: const TextStyle(color: Colors.white)),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() => _platformFilter = value);
                },
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Time Filter Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Ongoing', 'In next 24hrs', 'In next 7days'].map((filter) {
                  final isSelected = _timeFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _timeFilter = filter);
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.blue[500],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[800],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Contest List
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 64, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                'Connection Error',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                provider.error!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Troubleshooting:\n'
                                '1. Make sure backend server is running\n'
                                '2. Check network connection\n'
                                '3. If using physical device, update backend URL\n'
                                '   in lib/main.dart to your computer\'s IP address',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () => provider.refresh(),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : filteredContests.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.event_busy, size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text('No contests for filter: $_timeFilter'),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () => provider.refresh(),
                                  child: const Text('Refresh'),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => provider.refresh(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    '${filteredContests.length} contest${filteredContests.length != 1 ? 's' : ''}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredContests.length,
                                    itemBuilder: (ctx, i) {
                                      final c = filteredContests[i];
                                      return _ContestTile(c: c);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.refresh(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _ContestTile extends StatelessWidget {
  final Contest c;
  const _ContestTile({required this.c});
  
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startsIn = c.startTime.difference(now);
    
    String timeDisplay;
    if (startsIn.isNegative) {
      timeDisplay = 'In Progress';
    } else if (startsIn.inDays > 0) {
      timeDisplay = 'In ${startsIn.inDays}d ${startsIn.inHours % 24}h';
    } else {
      final hours = startsIn.inHours;
      final minutes = startsIn.inMinutes % 60;
      timeDisplay = 'In ${hours}h ${minutes}m';
    }
    
    final formatter = DateFormat('MMM dd, HH:mm');
    final startTimeStr = formatter.format(c.startTime);
    
    Color platformColor;
    switch (c.platform) {
      case 'Codeforces':
        platformColor = const Color(0xFF1F8ACB);
        break;
      case 'LeetCode':
        platformColor = const Color(0xFFFFA116);
        break;
      case 'CodeChef':
        platformColor = const Color(0xFF964B00);
        break;
      case 'AtCoder':
        platformColor = Colors.purple;
        break;
      default:
        platformColor = Colors.grey;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: platformColor.withValues(alpha: 0.2),
          child: Icon(Icons.code, color: platformColor),
        ),
        title: Text(
          c.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: platformColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    c.platform,
                    style: TextStyle(fontSize: 11, color: platformColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Text(startTimeStr, style: const TextStyle(fontSize: 11)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              timeDisplay,
              style: TextStyle(
                fontSize: 12,
                color: startsIn.isNegative ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, size: 16),
            const SizedBox(height: 2),
            Text(
              '${c.durationMinutes ~/ 60}h',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
