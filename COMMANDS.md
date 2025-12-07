# 🛠️ Command Reference

Quick reference for all Flutter and development commands.

## Essential Commands

### Run the App
```bash
# Navigate to project
cd /Users/aliazgorrumi/Development/cp_tracker

# Run on connected device
flutter run

# Run on specific device
flutter devices                    # List available devices
flutter run -d <device-id>        # Run on specific device

# Run in release mode
flutter run --release

# Run with hot reload (default in debug)
# Press 'r' in terminal to hot reload
# Press 'R' in terminal to hot restart
```

### Build the App
```bash
# Build APK (Android)
flutter build apk

# Build App Bundle (Android - for Play Store)
flutter build appbundle

# Build iOS (requires Mac)
flutter build ios

# Build with specific flavor
flutter build apk --flavor production
flutter build ios --flavor production
```

### Development Tools
```bash
# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Clean build artifacts
flutter clean

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Run tests
flutter test

# Check Flutter & Dart versions
flutter --version
dart --version

# Check for outdated packages
flutter pub outdated
```

## Project Management

### Create New Files
```bash
# Models
touch lib/models/new_model.dart

# Services
touch lib/services/new_service.dart

# Providers
touch lib/providers/new_provider.dart

# Screens
touch lib/screens/new_screen.dart
```

### Project Structure
```bash
# View directory tree
tree lib/

# Count lines of code
find lib -name '*.dart' | xargs wc -l

# List all Dart files
find lib -name '*.dart'
```

## Git Commands

### Version Control
```bash
# Initialize repo (if not done)
git init

# Check status
git status

# Stage all changes
git add .

# Commit
git commit -m "Description of changes"

# Push to remote
git push origin main

# Create tag for release
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0

# Create branch
git checkout -b feature/new-feature

# View git log
git log --oneline --graph
```

## Backend Commands

### Using Reference Backend
```bash
# Navigate to backend
cd /Users/aliazgorrumi/Development/contest-notifier-extension-main/backend

# Install dependencies
npm install

# Run locally
npm run dev
# or
npm start

# Deploy to Vercel
vercel
vercel --prod

# Check logs
vercel logs <deployment-url>
```

### Test Backend API
```bash
# Test endpoint with curl
curl "http://localhost:3000/contest/upcoming"

# Test with platforms filter
curl "http://localhost:3000/contest/upcoming?platforms=%5B%22Codeforces%22%5D"

# Test production
curl "https://your-app.vercel.app/contest/upcoming"

# Pretty print JSON
curl -s "http://localhost:3000/contest/upcoming" | jq .
```

## Device & Emulator Management

### Android
```bash
# List AVD (emulators)
flutter emulators

# Launch emulator
flutter emulators --launch <emulator-id>

# Alternative with Android Studio tools
emulator -list-avds
emulator -avd <avd-name>

# Install on connected device
flutter install

# Uninstall from device
adb uninstall com.example.cp_tracker

# View logs
flutter logs
adb logcat | grep flutter
```

### iOS (Mac only)
```bash
# List simulators
xcrun simctl list devices

# Boot simulator
xcrun simctl boot <device-udid>

# Open Simulator app
open -a Simulator

# Install on simulator
flutter install -d <simulator-id>
```

## Debugging Commands

### Inspect Running App
```bash
# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Connect to running app
flutter attach

# Performance overlay
# While app running, press 'p' in terminal

# Widget inspector
# Press 'i' in terminal

# Show performance metrics
# Press 'P' in terminal
```

### Troubleshooting
```bash
# Clear all build artifacts
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Reset pub cache
flutter pub cache repair

# Doctor check
flutter doctor -v

# Fix iOS pods (Mac)
cd ios
pod install
cd ..

# Fix Android Gradle
cd android
./gradlew clean
cd ..
```

## Notifications Testing

### Android
```bash
# Send test notification via adb
adb shell am broadcast -a com.google.android.c2dm.intent.RECEIVE

# Check notification settings
adb shell dumpsys notification

# Grant notification permission
adb shell pm grant com.example.cp_tracker android.permission.POST_NOTIFICATIONS
```

### iOS
```bash
# Reset notification permissions
xcrun simctl privacy <device> reset notifications com.example.cpTracker
```

## Performance Analysis

### Profile App
```bash
# Run in profile mode
flutter run --profile

# Build profile version
flutter build apk --profile
flutter build ios --profile

# Analyze app size
flutter build apk --analyze-size
flutter build appbundle --analyze-size
```

### Measure Build Times
```bash
# Time a build
time flutter build apk

# Verbose build output
flutter build apk --verbose
```

## Package Management

### Add Package
```bash
# Add to pubspec.yaml, then:
flutter pub get

# Or use flutter command
flutter pub add package_name
flutter pub add dev:package_name  # For dev dependencies
```

### Remove Package
```bash
# Remove from pubspec.yaml, then:
flutter pub get

# Or use flutter command
flutter pub remove package_name
```

### Update Specific Package
```bash
flutter pub upgrade package_name
```

## Code Generation (if using build_runner)

```bash
# Generate code once
flutter pub run build_runner build

# Watch for changes
flutter pub run build_runner watch

# Delete conflicting outputs
flutter pub run build_runner build --delete-conflicting-outputs
```

## Localization (if implementing)

```bash
# Generate localization files
flutter gen-l10n

# Or with intl_utils
flutter pub run intl_utils:generate
```

## Deployment Helpers

### Version Bump
```bash
# Edit pubspec.yaml version field
# version: 1.0.0+1
# Format: major.minor.patch+build

# Or use script
sed -i '' 's/version: .*/version: 1.0.1+2/' pubspec.yaml
```

### Release Signing (Android)
```bash
# Generate keystore
keytool -genkey -v -keystore ~/cp_tracker-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias key

# Verify keystore
keytool -list -v -keystore ~/cp_tracker-key.jks
```

### Screenshots
```bash
# Run on device
flutter run

# Take screenshot (while app running)
flutter screenshot

# Or use device tools
# Android: Volume Down + Power
# iOS: Side Button + Volume Up
```

## Useful Aliases

Add to `~/.zshrc` or `~/.bash_profile`:

```bash
# Flutter shortcuts
alias fr='flutter run'
alias fb='flutter build'
alias fc='flutter clean'
alias fa='flutter analyze'
alias fpg='flutter pub get'
alias fpu='flutter pub upgrade'

# Project specific
alias cptracker='cd /Users/aliazgorrumi/Development/cp_tracker'
alias runcp='cd /Users/aliazgorrumi/Development/cp_tracker && flutter run'

# Git shortcuts
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'

# After adding, reload shell
source ~/.zshrc
```

## Environment Variables

### Set Backend URL
```bash
# For development
export CONTEST_API_URL="http://localhost:3000/contest"

# For production
export CONTEST_API_URL="https://your-app.vercel.app/contest"

# Use in Dart
const apiUrl = String.fromEnvironment('CONTEST_API_URL', 
  defaultValue: 'https://default.example.com/contest'
);

# Run with environment variable
flutter run --dart-define=CONTEST_API_URL=http://localhost:3000/contest
```

## Quick Workflows

### Daily Development
```bash
# 1. Pull latest changes
git pull

# 2. Get dependencies
flutter pub get

# 3. Run app
flutter run

# 4. Make changes (hot reload with 'r')

# 5. Analyze
flutter analyze

# 6. Commit
git add .
git commit -m "Feature: description"
git push
```

### Release Workflow
```bash
# 1. Update version in pubspec.yaml

# 2. Clean & analyze
flutter clean
flutter analyze

# 3. Build release
flutter build apk --release
flutter build appbundle --release

# 4. Test release build
flutter install --release

# 5. Tag release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# 6. Upload to stores
```

### Troubleshooting Workflow
```bash
# 1. Clean everything
flutter clean
rm -rf build/ .dart_tool/

# 2. Doctor check
flutter doctor -v

# 3. Get dependencies
flutter pub get

# 4. Try run
flutter run

# 5. If iOS issues (Mac)
cd ios && pod install && cd ..

# 6. If Android issues
cd android && ./gradlew clean && cd ..

# 7. Last resort: upgrade Flutter
flutter upgrade
```

## Monitoring & Logs

### Real-time Logs
```bash
# Flutter logs
flutter logs

# Android logs
adb logcat -s flutter

# iOS logs (Mac)
idevicesyslog

# Filter logs
flutter logs | grep "ERROR"
flutter logs | grep "CP Tracker"
```

### Backend Logs
```bash
# Local backend
npm run dev  # Logs appear in terminal

# Vercel logs
vercel logs --follow

# Heroku logs
heroku logs --tail
```

## Documentation

### Generate Docs
```bash
# Install dartdoc
flutter pub global activate dartdoc

# Generate documentation
dartdoc

# Open documentation
open doc/api/index.html
```

---

**Pro Tip**: Bookmark this file for quick reference during development!

*Most used commands: `flutter run`, `flutter pub get`, `flutter clean`, `flutter analyze`*
