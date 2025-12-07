# CP Tracker - Project Structure

## 📁 Directory Overview

```
cp_tracker/
├── lib/
│   ├── main.dart                          # App entry point with providers
│   ├── models/                            # Data models
│   │   ├── contest.dart                   # Contest data structure
│   │   ├── problem_log.dart               # Individual problem record
│   │   ├── day_stats.dart                 # Daily statistics
│   │   └── streak_state.dart              # Streak tracking state
│   ├── services/                          # Business logic & external APIs
│   │   ├── storage_service.dart           # Local persistence (SharedPreferences)
│   │   ├── contest_service.dart           # HTTP contest fetching
│   │   ├── notification_service.dart      # Push notifications
│   │   └── quotes_service.dart            # Motivational quotes
│   ├── providers/                         # State management (Provider pattern)
│   │   ├── problem_tracker_provider.dart  # Problem logging & streak logic
│   │   ├── contest_provider.dart          # Contest data & notifications
│   │   └── notification_provider.dart     # Notification initialization
│   └── screens/                           # UI screens
│       ├── dashboard_screen.dart          # Main screen with progress/streak
│       ├── log_problem_screen.dart        # Problem entry form
│       ├── contests_screen.dart           # Upcoming contests list
│       ├── settings_screen.dart           # App settings & preferences
│       └── statistics_screen.dart         # Analytics & charts
├── pubspec.yaml                           # Dependencies & metadata
├── README.md                              # Comprehensive documentation
└── QUICK_START.md                         # User guide

## 🔄 Data Flow

### Problem Logging Flow
```
User Taps + Button
    ↓
LogProblemScreen (UI)
    ↓
ProblemTrackerProvider.logProblem()
    ↓
├─→ Add to in-memory list
├─→ Save to StorageService (SharedPreferences)
├─→ Recalculate streak logic
└─→ notifyListeners() → UI updates
    ↓
Dashboard shows updated count & streak
```

### Streak Calculation Logic
```
On each problem log:
1. Group all problems by day
2. Count problems per day
3. Check if today ≥ threshold (3)
4. If yes:
   - Check if yesterday also met threshold
   - If consecutive: increment streak
   - If not: reset streak to 1
5. Track max streak
6. Save state to persistent storage
```

### Contest Notification Flow
```
ContestProvider.refresh()
    ↓
ContestService.fetchUpcoming() (HTTP)
    ↓
Parse JSON → List<Contest>
    ↓
NotificationService.scheduleContestReminders()
    ↓
For each contest starting within 24h:
    └─→ Schedule notification 15min before
```

## 🎨 UI Architecture

### Navigation Structure
```
HomeShell (Bottom Navigation)
├── Dashboard Tab
│   ├── Daily Quote Card
│   ├── Progress Card (gradient)
│   ├── Streak Stats (2 cards)
│   ├── Log Problem Button
│   └── Recent Problems List
├── Contests Tab
│   ├── Upcoming Contests ListView
│   └── Refresh FAB
└── Settings Tab
    ├── Statistics Link
    ├── Notification Toggles
    ├── Streak Info
    └── About Section

Modal Routes:
├── /log → LogProblemScreen
└── /statistics → StatisticsScreen
```

## 📦 Dependencies Usage

| Package | Purpose | Used In |
|---------|---------|---------|
| `provider` | State management | All screens, main.dart |
| `shared_preferences` | Local storage | StorageService |
| `http` | Contest API calls | ContestService |
| `flutter_local_notifications` | Push notifications | NotificationService |
| `timezone` | Notification scheduling | NotificationService |
| `intl` | Date formatting | Contest displays |

## 🔔 Notification System

### Channels
1. **motivation_channel** - Daily 9 AM reminder
2. **hourly_channel** - 10 AM, 2 PM, 6 PM, 9 PM reminders
3. **contest_channel** - Contest alerts (15 min before)
4. **instant_channel** - Manual push from Settings

### Notification IDs
- 100: Daily motivation
- 200-203: Hourly reminders
- 1000+: Dynamic contest reminders

## 💾 Data Models

### ProblemLog
```dart
{
  timestamp: DateTime,
  platform: String,
  difficulty: String,
  problemId: String?
}
```

### StreakState
```dart
{
  currentStreak: int,
  maxStreak: int,
  lastUpdatedDay: DateTime?
}
```

### Contest
```dart
{
  platform: String,
  name: String,
  startTime: DateTime,
  endTime: DateTime,
  durationMinutes: int,
  url: String?
}
```

## 🎯 Key Features Implementation

### Gradient Cards
- Dashboard: Purple gradient for quote
- Dashboard: Green/Red gradient for progress (changes based on target)
- Statistics: Purple gradient for total count

### Motivational Quotes
- 20 CP-focused quotes
- Rotates daily based on day of year
- Displayed in purple gradient card on dashboard

### Statistics Charts
- Platform distribution with color-coded bars
- Difficulty breakdown with semantic colors
- 7-day activity bar chart with gradient fills

### Streak Protection
- Real-time progress indicator
- Warning message when < 3 problems
- Celebration message when target met
- Visual feedback with color changes

## 🚀 Performance Considerations

### Optimizations
- Local storage for instant load times
- Provider pattern for efficient rebuilds
- Lazy loading of contest data
- Cached quotes (no external calls)

### Scalability
- Can handle 1000s of problem logs
- Efficient day grouping algorithms
- O(n) complexity for streak calculation
- Minimal network requests

## 🔐 Privacy & Security

### Data Storage
- All user data stored locally
- No analytics or tracking
- No user accounts required
- No cloud dependencies (except contest API)

### Permissions Required
- Notifications (for reminders)
- Network (for contest fetching)

## 🧪 Testing Recommendations

### Manual Testing Checklist
- [ ] Log 3 problems → verify streak increments
- [ ] Skip a day → verify streak resets
- [ ] Enable notifications → receive daily push
- [ ] Fetch contests → verify list updates
- [ ] View statistics → check all charts render
- [ ] Change platform/difficulty → verify filters

### Edge Cases to Test
- [ ] First-time app launch (empty state)
- [ ] Crossing midnight boundary
- [ ] Logging problem at 23:59
- [ ] Network failure on contest fetch
- [ ] 0 problems logged ever
- [ ] All platforms used equally

## 📊 Analytics Tracked (Locally)

### User Progress
- Total problems solved
- Current streak
- Max streak achieved
- Problems per platform
- Problems per difficulty
- Daily activity (last 7 days)

### No External Analytics
- No Firebase Analytics
- No Mixpanel
- No third-party trackers
- Completely private

---

**Architecture Philosophy**: Simple, local-first, privacy-focused, and motivational. Every feature designed to push users toward consistent competitive programming practice.
