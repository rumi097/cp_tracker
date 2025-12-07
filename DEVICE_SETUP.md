# 📱 Physical Device Setup Guide

## Problem: localhost doesn't work on physical devices

When you run the app on a physical Android/iOS device, `localhost:3000` refers to the **phone itself**, not your computer. You need to use your computer's local IP address.

## Solution: Update Backend URL

### Step 1: Find Your Computer's IP Address

**On macOS:**
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

**On Windows:**
```cmd
ipconfig
```
Look for "IPv4 Address" under your active network adapter.

**On Linux:**
```bash
hostname -I
```

You'll get something like: `192.168.1.100`

### Step 2: Update lib/main.dart

Open `lib/main.dart` and find line ~30:

```dart
const backendUrl = 'http://localhost:3000';
```

Replace with your computer's IP:

```dart
const backendUrl = 'http://192.168.1.100:3000';  // Use YOUR IP here
```

### Step 3: Make Sure Backend is Running

```bash
cd backend
node server.js
```

You should see:
```
🚀 CP Tracker Backend running on http://localhost:3000
```

### Step 4: Test from Phone Browser

Before running the app, test in your phone's web browser:
```
http://192.168.1.100:3000/health
```

If you see `{"status":"ok", ...}`, you're good to go!

### Step 5: Rebuild and Run

```bash
flutter run
```

## Troubleshooting

### ❌ Connection Refused

**Problem:** Phone and computer not on same WiFi network

**Solution:** 
- Make sure both devices are connected to the same WiFi
- Check if firewall is blocking port 3000
- Try disabling VPN on computer

### ❌ Still Getting Errors

**macOS Firewall:**
```bash
sudo lsof -i :3000  # Check if server is running
```

**Allow incoming connections:**
- System Preferences → Security & Privacy → Firewall → Firewall Options
- Allow incoming connections for Node.js

## For Production

Deploy your backend to:
- **Vercel** (recommended): `vercel deploy`
- **Heroku**: `git push heroku main`
- **Railway**: Railway.app deploy

Then update `backendUrl` to your production URL:
```dart
const backendUrl = 'https://your-app.vercel.app';
```

## Bangladesh Time Configuration

The app is already configured for Bangladesh timezone (Asia/Dhaka). Notifications will be sent according to Bangladesh time:
- Daily Motivation: 9:00 AM BDT
- Hourly Reminders: 10AM, 2PM, 6PM, 9PM BDT
