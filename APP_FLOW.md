# 📱 App Flow & User Journey

## Visual Navigation Map

```
┌─────────────────────────────────────────────────────┐
│                    APP LAUNCH                       │
│            Initialize Providers & Services           │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│              HOME SHELL (Bottom Nav)                │
│  ┌──────────┬──────────┬──────────┐                │
│  │Dashboard │ Contests │ Settings │                │
│  └──────────┴──────────┴──────────┘                │
└─────────────────────────────────────────────────────┘
         │            │            │
         ▼            ▼            ▼
    
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│  DASHBOARD  │  │  CONTESTS   │  │  SETTINGS   │
│             │  │             │  │             │
│ • Quote     │  │ • Contest   │  │ • Stats     │
│ • Progress  │  │   List      │  │   Link      │
│ • Streaks   │  │ • Countdown │  │ • Notifs    │
│ • Log Btn   │  │ • Refresh   │  │ • Threshold │
│ • Recent    │  │             │  │ • About     │
└──────┬──────┘  └─────────────┘  └──────┬──────┘
       │                                  │
       │ Tap +                   Tap Stats Link
       ▼                                  ▼
┌─────────────┐                  ┌─────────────┐
│ LOG PROBLEM │                  │ STATISTICS  │
│             │                  │             │
│ • Platform  │                  │ • Total     │
│ • Difficulty│                  │ • Platforms │
│ • Problem ID│                  │ • Difficulty│
│ • Save Btn  │                  │ • 7-Day     │
└──────┬──────┘                  └─────────────┘
       │
       │ Tap Save
       ▼
   Updates:
   • Dashboard count
   • Streak calculation
   • Recent list
   • Statistics
```

## User Journey - First Week

### Day 1: Onboarding
```
1. Install app
2. Open app → See empty dashboard
3. Navigate to Settings tab
4. Enable "Daily Motivation Notification"
5. See permission dialog → Grant
6. Return to Dashboard
7. Tap + (Floating Action Button)
8. Fill problem log form:
   - Platform: Codeforces
   - Difficulty: Easy
   - Problem ID: 1A
9. Tap Save
10. See dashboard update:
    - Today: 1/3
    - Progress bar: 33%
    - Message: "Solve 2 more..."
    - Current Streak: 0
```

### Day 1: Building Momentum
```
11. Solve another problem
12. Log it → Today: 2/3
13. Progress bar: 66%
14. Still streak 0 (need 3)

15. Solve third problem
16. Log it → Today: 3/3
17. Progress bar: 100% (full!)
18. Card turns GREEN
19. Message: "Streak secured!"
20. Current Streak: 1 ✨
21. Max Streak: 1
```

### Day 2: Morning Notification
```
9:00 AM
├─ 📱 Notification appears
│  "Keep the streak alive!"
│  "Solve at least 3 problems today..."
│
└─ User taps notification
   └─ App opens to Dashboard
      └─ Shows yesterday's success
         └─ Today: 0/3 (fresh start)
```

### Day 2: Throughout the Day
```
10:00 AM → 📱 "Time to code! 💻"
14:00 PM → 📱 "Practice makes perfect! 🎯"
18:00 PM → 📱 "One problem closer to mastery! 🚀"
21:00 PM → 📱 "Keep grinding! ⚡"

After each reminder:
└─ Solve 1 problem
   └─ Log immediately
      └─ Watch progress grow
```

### Day 2: Evening Success
```
After 3rd problem:
├─ Streak: 2 (consecutive days!)
├─ Max Streak: 2 (new record)
└─ Dashboard celebrates with colors
```

### Day 3-7: Building Habit
```
Day 3: Streak 3, Max 3
Day 4: Streak 4, Max 4
Day 5: Streak 5, Max 5
Day 6: Streak 6, Max 6
Day 7: Streak 7, Max 7 🎉

User now:
├─ Checks app daily
├─ Responds to notifications
├─ Tracks in Statistics
└─ Never wants to break chain
```

## Feature Usage Patterns

### Daily Routine Flow
```
Morning (9 AM)
└─ 📱 Daily notification
   └─ Open app
      └─ Check yesterday's progress
         └─ See motivational quote
            └─ Feel motivated

During Day (10 AM, 2 PM, 6 PM, 9 PM)
└─ 📱 Hourly reminder
   └─ Solve 1 problem
      └─ Log immediately
         └─ See progress update
            └─ Feel accomplished

Evening
└─ Open app
   └─ Review today's completion
      └─ Check Statistics screen
         └─ View weekly chart
            └─ Plan tomorrow
```

### Contest Preparation Flow
```
Open Contests Tab
└─ See upcoming contests
   └─ Note interesting ones
      └─ Get notification 15 min before
         └─ Prepare setup
            └─ Join contest
               └─ Compete!
```

### Statistics Review Flow
```
Settings Tab
└─ Tap "View Statistics"
   └─ See total problems (pride!)
      └─ Review platform distribution
         └─ Notice imbalance (too much LC?)
            └─ Decide to try CF
               └─ Adjust practice plan
```

## Notification Flow

### Setup Flow
```
First Launch
└─ Settings Tab
   └─ Toggle "Daily Motivation"
      └─ Request permissions (iOS/Android dialog)
         ├─ User Allows
         │  └─ NotificationProvider.init()
         │     ├─ Schedule daily 9 AM
         │     ├─ Schedule hourly (4 times)
         │     └─ Return to app
         │        └─ Toggle shows "enabled"
         │
         └─ User Denies
            └─ App works but no notifications
               └─ User can re-enable in device settings
```

### Daily Notification
```
9:00 AM Every Day
└─ Device shows notification
   ├─ User taps → Opens app to Dashboard
   ├─ User swipes away → Dismissed (will retry tomorrow)
   └─ User ignores → Badge on app icon
```

### Contest Notification
```
Contest starts at 16:00
└─ User refreshes Contests tab at 14:00
   └─ App schedules notification for 15:45
      └─ 15:45: Device shows notification
         ├─ Title: "Contest starts soon (Codeforces)"
         ├─ Body: "Round #900 begins in 15 minutes. Prepare!"
         └─ User taps → Opens Contests tab
```

## Data Flow

### Problem Logging Data Flow
```
User Fills Form
└─ Taps Save
   └─ ProblemTrackerProvider.logProblem()
      ├─ Create ProblemLog object
      │  └─ timestamp: now()
      │     platform: "Codeforces"
      │     difficulty: "Medium"
      │     problemId: "1234B"
      │
      ├─ Add to _logs list (in-memory)
      │
      ├─ StorageService.saveProblemLogs()
      │  └─ Convert to JSON
      │     └─ Save to SharedPreferences
      │        └─ Persist to disk
      │
      ├─ _recalculateStreak()
      │  └─ Group logs by day
      │     └─ Count problems per day
      │        └─ Check threshold (≥3?)
      │           └─ Update streak logic
      │              └─ Save StreakState
      │
      └─ notifyListeners()
         └─ Dashboard rebuilds
            ├─ Update today count
            ├─ Update progress bar
            ├─ Update streak cards
            └─ Update recent list
```

### Contest Fetching Data Flow
```
User Taps Refresh
└─ ContestProvider.refresh()
   └─ Set loading = true
      └─ UI shows spinner
         └─ ContestService.fetchUpcoming()
            └─ HTTP GET to backend
               ├─ Success (200)
               │  └─ Parse JSON
               │     └─ Convert to Contest objects
               │        └─ Sort by startTime
               │           └─ Set _contests list
               │              └─ NotificationService.scheduleContestReminders()
               │                 └─ For each contest within 24h:
               │                    └─ Schedule notification
               │                       └─ Set loading = false
               │                          └─ notifyListeners()
               │                             └─ UI shows contests
               │
               └─ Error (500/timeout)
                  └─ Set error message
                     └─ Set loading = false
                        └─ notifyListeners()
                           └─ UI shows error
```

## State Management Diagram

```
                    ┌──────────────────┐
                    │   main.dart      │
                    │  MultiProvider   │
                    └────────┬─────────┘
                             │
                             ├─────────────────────────────┐
                             │                             │
              ┌──────────────▼─────────┐     ┌────────────▼────────────┐
              │ ProblemTrackerProvider │     │   ContestProvider       │
              │                        │     │                         │
              │ • logs: List           │     │ • contests: List        │
              │ • streak: StreakState  │     │ • loading: bool         │
              │ • streakThreshold: 3   │     │ • error: String?        │
              │                        │     │                         │
              │ Methods:               │     │ Methods:                │
              │ • load()               │     │ • refresh()             │
              │ • logProblem()         │     │                         │
              │ • problemsSolvedToday()│     │                         │
              └───────────┬────────────┘     └────────────┬────────────┘
                          │                               │
                          │                               │
              ┌───────────▼────────────┐     ┌────────────▼────────────┐
              │   StorageService       │     │   ContestService        │
              │                        │     │                         │
              │ • loadProblemLogs()    │     │ • fetchUpcoming()       │
              │ • saveProblemLogs()    │     │   (HTTP GET)            │
              │ • loadStreakState()    │     │                         │
              │ • saveStreakState()    │     │                         │
              └────────────────────────┘     └─────────────────────────┘

                    ┌──────────────────┐
                    │NotificationProvider│
                    │                    │
                    │ • initialized      │
                    │                    │
                    │ Methods:           │
                    │ • init()           │
                    │ • pushInstant()    │
                    └─────────┬──────────┘
                              │
                    ┌─────────▼──────────┐
                    │NotificationService │
                    │                    │
                    │ • init()           │
                    │ • scheduleDailyMot.│
                    │ • scheduleHourly() │
                    │ • scheduleContest()│
                    │ • instantPush()    │
                    └────────────────────┘
```

## Streak Calculation Algorithm

```
Input: New problem logged at timestamp T

Step 1: Group all logs by calendar day
┌─────────────────────────────────────┐
│ Day        | Problems               │
├─────────────────────────────────────┤
│ 2025-11-19 | [log1, log2, log3]     │
│ 2025-11-20 | [log4, log5, log6, log7]│
│ 2025-11-21 | [log8, log9, log10]    │ ← Today
└─────────────────────────────────────┘

Step 2: Count problems per day
┌─────────────────────┐
│ Day        | Count  │
├─────────────────────┤
│ 2025-11-19 | 3      │
│ 2025-11-20 | 4      │
│ 2025-11-21 | 3      │
└─────────────────────┘

Step 3: Check threshold (≥3)
┌──────────────────────────┐
│ Day        | Meets? (≥3) │
├──────────────────────────┤
│ 2025-11-19 | ✓ Yes       │
│ 2025-11-20 | ✓ Yes       │
│ 2025-11-21 | ✓ Yes       │
└──────────────────────────┘

Step 4: Calculate streak
yesterday = 2025-11-20
yesterday_met = true

today = 2025-11-21
today_met = true

if (today_met && yesterday_met):
    streak = previous_streak + 1
    → 2 + 1 = 3

if (today_met && !yesterday_met):
    streak = 1

if (!today_met):
    streak = 0

Step 5: Update max streak
if (current_streak > max_streak):
    max_streak = current_streak
    → max(3, 2) = 3

Step 6: Save state
StreakState {
    currentStreak: 3,
    maxStreak: 3,
    lastUpdatedDay: 2025-11-21
}
→ Save to SharedPreferences
```

## Error Handling Flow

### Network Error (Contest Fetch)
```
User taps Refresh
└─ HTTP request fails
   └─ Catch exception
      └─ Set error = "Failed to fetch"
         └─ notifyListeners()
            └─ UI shows error message
               └─ User can retry
```

### Storage Error (Rare)
```
App tries to save logs
└─ SharedPreferences fails
   └─ Catch exception
      └─ Keep data in memory
         └─ Retry on next log
            └─ Or show warning to user
```

### Notification Permission Denied
```
User toggles notification
└─ Request permission
   └─ User denies
      └─ Toggle stays off
         └─ User can enable in Settings
            └─ Or grant in device settings
```

---

**This visual guide shows the complete user experience and technical data flows. Everything works together to create a seamless, motivating competitive programming tracker!**
