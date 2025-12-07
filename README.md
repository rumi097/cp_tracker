# CP Tracker 🔥

Your ultimate competitive programming companion! Stay motivated, track your progress, and never miss a contest. Built with Flutter to push you towards coding excellence every single day.

## 🆕 Latest Updates (November 2025)

- ✨ **Automatic Problem Tracking** - Sync from Codeforces, LeetCode, AtCoder
- 🎨 **Darker Professional Theme** - Dark indigo color scheme
- ⚙️ **Customizable Streak Threshold** - Adjust from 1-10 problems/day
- 🇧🇩 **Bangladesh Timezone** - All times configured for Asia/Dhaka
- 📱 **Enhanced Settings** - Username management and sync controls
- 🔧 **Better Error Handling** - Detailed troubleshooting for connection issues

See [UPDATES.md](UPDATES.md) for complete details.

---

## ✨ Features

### 📊 Progress Tracking
- **Real-time daily problem counter** with beautiful gradient progress bars
- **Automatic streak tracking** - maintains your streak when you solve ≥3 problems/day
- **Maximum streak memory** - celebrate your best performance
- **Smart streak logic** - resets if you miss a day, extends when you maintain consistency

### 📈 Analytics & Statistics
- **Platform breakdown** - visualize which platforms you use most (Codeforces, LeetCode, CodeChef, AtCoder, GeeksforGeeks, CodingNinjas)
- **Difficulty distribution** - track your problem difficulty preferences
- **7-day activity chart** - beautiful bar chart showing your weekly consistency
- **Total problems counter** - keep track of your overall progress

### 🎯 Motivation System
- **Daily motivational quotes** - CP-focused quotes that change each day
- **Gradient UI cards** - visually appealing design that celebrates your progress
- **Instant encouragement** - send yourself a motivational push notification anytime
- **Progress indicators** - color-coded cards showing if you're on track

### 🔔 Smart Notifications
- **Daily motivation** at 9:00 AM - reminder to maintain your streak
- **Hourly reminders** at 10 AM, 2 PM, 6 PM, and 9 PM - gentle nudges throughout the day
- **Contest alerts** - 15-minute warnings before contests start (within 24h window)
- **Customizable notifications** - enable/disable as needed

### 🏆 Contest Integration
- **Upcoming contests list** from multiple platforms
- **Auto-scheduled reminders** for contests starting soon
- **Real-time countdown** to contest start times
- **Platform-specific contest information**

### 📝 Problem Logging
- **Quick entry form** - log problems with platform, difficulty, and optional problem ID
- **Recent problems list** - see your last 10 solved problems on dashboard
- **Persistent storage** - all data saved locally using SharedPreferences

## 🚀 Getting Started

### Quick Start (Easiest)

```bash
cd /Users/aliazgorrumi/Development/cp_tracker
./run.sh
```

This script will:
1. Install backend dependencies
2. Start the Node.js backend server
3. Get Flutter dependencies
4. Run the Flutter app

### Manual Setup

#### 1. Start the Backend

```bash
cd backend
npm install
npm start
```

Backend runs on `http://localhost:3000`

#### 2. Run the Flutter App

```bash
# In a new terminal
cd /Users/aliazgorrumi/Development/cp_tracker
flutter pub get
flutter run
```

### Testing on Physical Device

If testing on a physical device (not emulator):

1. Find your computer's local IP:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

2. Update `lib/main.dart`:
```dart
final contestService = ContestService(
  baseUrl: 'http://YOUR_LOCAL_IP:3000/contest'  // e.g., http://192.168.1.100:3000/contest
);
```

3. Ensure phone and computer are on same WiFi network

### First Launch Setup
1. **Start Backend**: Run `./run.sh` or manually start backend with `cd backend && npm start`
2. **Enable Notifications**: Go to Settings → Toggle "Daily Motivation Notification"
3. **Test Contests**: Go to Contests tab → Tap refresh to fetch contests
4. **Start Logging**: Tap the + button to log your first problem!

## ⚙️ Configuration

### Backend Setup (Integrated!)

The project includes a **built-in Node.js backend** in the `backend/` folder that fetches contest data from:
- ✅ Codeforces (official API)
- ✅ LeetCode (GraphQL API)
- ✅ CodeChef (public API)

**Default Configuration:**
- Backend runs on `http://localhost:3000`
- Flutter app configured to use `http://localhost:3000/contest`
- No external deployment needed for local development!

**API Response Format:**
```json
{
  "platforms": ["Codeforces", "LeetCode"],
  "upcoming_contests": [
    {
      "platform": "Codeforces",
      "name": "Codeforces Round #123",
      "startTime": 1732200000,  // Unix epoch seconds
      "endTime": 1732207200,    // Unix epoch seconds  
      "duration": 120,          // Minutes
      "url": "https://codeforces.com/contest/123"
    }
  ]
}
```

### Customizing Streak Threshold

Default is 3 problems/day. To change, modify in `lib/main.dart`:

```dart
ChangeNotifierProvider(
  create: (_) => ProblemTrackerProvider(storage, streakThreshold: 5)..load()
)
```

### Notification Times

Adjust reminder times in `lib/services/notification_service.dart`:

```dart
// Daily motivation hour (default 9 AM)
await scheduleDailyMotivation(hour: 8);

// Hourly reminder times (default 10, 14, 18, 21)
await scheduleHourlyReminders(hours: [9, 15, 20]);
```

## 📱 App Screens

1. **Dashboard** - Your command center with streak, progress, quotes, and recent problems
2. **Contests** - Upcoming contests from all platforms with countdown timers
3. **Statistics** - Detailed analytics on platforms, difficulties, and weekly activity
4. **Settings** - Manage notifications, view stats link, and app info
5. **Log Problem** - Quick form to record solved problems

## 🎨 UI Highlights

- **Gradient cards** with smooth color transitions
- **Animated progress bars** that celebrate your achievements
- **Color-coded stats** - green when on track, orange/red when behind
- **Material Design 3** - modern, clean interface
- **Responsive layout** - works on phones and tablets

## 🧠 Streak Logic Explained

1. **Daily Threshold**: Solve ≥3 problems in a day (configurable)
2. **Streak Increment**: If today meets threshold AND yesterday met threshold → streak++
3. **Streak Start**: If today meets threshold but yesterday didn't → streak = 1
4. **Streak Reset**: If yesterday didn't meet threshold → streak = 0 (until today meets it)
5. **Max Streak**: Automatically tracks and displays your best ever streak

## 🔐 Data Privacy

- All data stored **locally** on your device using SharedPreferences
- No cloud sync, no external databases
- Your progress is completely private

## 🛠️ Tech Stack

- **Flutter** - Cross-platform framework
- **Provider** - State management
- **SharedPreferences** - Local persistence
- **flutter_local_notifications** - Push notifications
- **timezone** - Notification scheduling
- **http** - Contest API fetching
- **intl** - Date formatting

## 🚧 Future Enhancements

- [ ] Direct platform API integration for auto-logging
- [ ] Cloud sync with Firebase/Supabase
- [ ] Friend leaderboards and challenges
- [ ] XP system and achievement badges
- [ ] Rating/ELO graph over time
- [ ] Problem recommendation engine
- [ ] Decay mechanics for extended breaks
- [ ] Dark mode toggle
- [ ] Export data to CSV/JSON

## 🎯 Motivation Philosophy

This app is designed on the principle that **consistency beats intensity**. Solving 3 problems daily builds lasting skills faster than cramming 20 problems once a week.

The streak system, hourly reminders, and motivational quotes work together to create positive reinforcement loops that make competitive programming a daily habit rather than an occasional activity.

## 📄 License

Internal development sample. Adapt licensing as needed for your use case.

## 🤝 Contributing

This is a personal project template. Feel free to fork and customize for your own competitive programming journey!

---

**Built with ❤️ for competitive programmers who want to stay consistent and motivated.**

*"Practice doesn't make perfect. Perfect practice makes perfect."*# cp_tracker
