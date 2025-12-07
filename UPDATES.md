# CP Tracker - Latest Updates

## 🆕 New Features Added

### 1. **Automatic Problem Tracking** ✨
- Configure your platform usernames in Settings
- Tap "Sync Now" to automatically fetch today's accepted submissions
- Supports: Codeforces, LeetCode, AtCoder (CodeChef requires manual entry)
- No need to manually log every problem!

### 2. **Customizable Streak Threshold** 🔥
- Adjust the daily problem requirement (1-10 problems/day)
- Use +/- buttons in Settings → Streak Settings
- Default: 3 problems/day

### 3. **Dark Theme** 🌙
- Darker, more professional color scheme
- Dark blue (indigo) primary colors
- Better contrast and readability
- Reduced eye strain for long coding sessions

### 4. **Enhanced Contest Display** 📅
- Platform-specific color coding
- Better error handling with troubleshooting tips
- Shows days/hours until contest starts
- Displays contest duration and status

### 5. **Bangladesh Timezone Support** 🇧🇩
- All times configured for Asia/Dhaka timezone
- Notifications aligned with Bangladesh time
- Contest times displayed in local time

### 6. **Improved Settings Panel** ⚙️
- Platform username management
- Visual streak threshold controls
- Better organized sections
- Sync status indicators

---

## 🚀 Quick Start Guide

### Step 1: Start the Backend Server

```bash
cd /Users/aliazgorrumi/Development/cp_tracker
./run.sh
```

### Step 2: Configure for Physical Device (Important!)

If testing on a physical device, update the backend URL:

1. Find your computer's IP address:
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   ```
   Example output: `inet 192.168.1.100`

2. Edit `lib/main.dart` line 26:
   ```dart
   const backendUrl = 'http://192.168.1.100:3000'; // Use your IP
   ```

3. Rebuild the app:
   ```bash
   flutter run
   ```

### Step 3: Set Up Auto-Sync

1. Open the app → Settings tab
2. Enter your usernames:
   - **Codeforces**: Your CF handle
   - **LeetCode**: Your LC username
   - **AtCoder**: Your AC username
   - **CodeChef**: (Manual logging required)
3. Tap "Save Usernames"
4. Tap "Sync Now" to fetch today's problems

### Step 4: Customize Your Experience

1. **Adjust Streak Threshold**: Settings → Streak Settings → Use +/- buttons
2. **Enable Notifications**: Settings → Toggle "Enable Notifications"
3. **View Statistics**: Settings → "View Statistics"

---

## 🔧 Troubleshooting

### "Connection refused" error on physical device:
- Make sure backend is running on your computer
- Update `lib/main.dart` with your computer's local IP (not localhost)
- Both devices must be on the same WiFi network
- Firewall might be blocking port 3000

### Contests not showing:
1. Check backend server is running: `curl http://localhost:3000/health`
2. Check network connection
3. Try manual refresh (pull down or tap refresh button)
4. Check logs in terminal for API errors

### Auto-sync not working:
- Verify usernames are correct (case-sensitive)
- Check backend is accessible
- LeetCode GraphQL might have rate limits
- CodeChef requires manual logging (no public API)

### Notifications not appearing:
- Enable in Settings first
- Grant notification permissions when prompted
- Check device notification settings
- iOS: Ensure app has notification permissions in Settings

---

## 📊 Feature Comparison

| Feature | Before | After |
|---------|--------|-------|
| Problem Logging | Manual only | Automatic + Manual |
| Streak Threshold | Fixed (3) | Adjustable (1-10) |
| Theme | Light purple | Dark indigo |
| Contest Errors | Generic message | Detailed troubleshooting |
| Timezone | UTC | Bangladesh (Asia/Dhaka) |
| Settings UI | Basic | Advanced with sections |

---

## 🎯 Usage Tips

1. **Daily Routine**:
   - Morning: Check contests tab
   - After solving: Tap "Sync Now" (or log manually)
   - Evening: Check if streak threshold met

2. **Platform Priority**:
   - **Auto-sync reliable**: Codeforces, LeetCode, AtCoder
   - **Manual required**: CodeChef

3. **Streak Strategy**:
   - Set threshold based on your schedule
   - Start with 2-3 for consistency
   - Increase gradually as you improve

4. **Backend Options**:
   - **Development**: localhost (emulator/simulator)
   - **Physical device**: Local IP address
   - **Production**: Deploy to Vercel/Heroku (update URL in main.dart)

---

## 📝 API Endpoints Reference

Backend now includes:

- `GET /contest/upcoming` - Fetch contests
- `GET /api/submissions/codeforces/:username` - CF submissions
- `GET /api/submissions/leetcode/:username` - LC submissions  
- `GET /api/submissions/atcoder/:username` - AC submissions
- `GET /api/submissions/codechef/:username` - CC submissions (placeholder)
- `GET /health` - Server health check

---

## 🔄 Next Steps

1. Test auto-sync with your platform usernames
2. Adjust streak threshold to your preference
3. Enable notifications for daily reminders
4. Deploy backend for production use (optional)
5. Share feedback for future improvements!

---

**Note**: All notifications and times are configured for Bangladesh timezone (UTC+6).
