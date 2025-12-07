# 🚀 Deployment Checklist

Use this checklist before launching your CP Tracker app!

## Pre-Flight Checks

### ✅ Code Quality
- [x] Flutter analyze shows no issues
- [x] All deprecation warnings fixed
- [x] No compilation errors
- [x] Dependencies resolved

### ✅ Features Verification
- [ ] Dashboard displays correctly
- [ ] Problem logging works
- [ ] Streak increments properly
- [ ] Statistics screen renders
- [ ] Contests screen loads (with backend)
- [ ] Settings toggles function
- [ ] Notifications can be enabled

### ✅ Backend Configuration
- [ ] Backend URL updated in `lib/main.dart`
- [ ] Backend deployed and accessible
- [ ] API endpoint returns correct format
- [ ] Contest data refreshes successfully

## Platform-Specific Setup

### 📱 iOS Deployment

#### 1. Notification Permissions
Update `ios/Runner/Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

#### 2. App Icons
- [ ] Replace default icon in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- [ ] Ensure all sizes provided (1024x1024 for App Store)

#### 3. Bundle ID
- [ ] Set in Xcode: Open `ios/Runner.xcworkspace`
- [ ] Change bundle identifier to your unique ID
- [ ] Update in `Info.plist`

#### 4. Build & Test
```bash
flutter build ios --release
```

### 🤖 Android Deployment

#### 1. Notification Permissions
Already configured in manifest, but verify:
`android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

#### 2. App Icon
- [ ] Replace icon in `android/app/src/main/res/mipmap-*/ic_launcher.png`
- [ ] Use Android Asset Studio for proper sizing

#### 3. Package Name
Update in `android/app/build.gradle`:
```gradle
applicationId "com.yourcompany.cp_tracker"
```

#### 4. Signing Config
Create `android/key.properties`:
```
storePassword=<password>
keyPassword=<password>
keyAlias=key
storeFile=<path-to-keystore>
```

Generate keystore:
```bash
keytool -genkey -v -keystore ~/cp_tracker-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

#### 5. Build & Test
```bash
flutter build apk --release
flutter build appbundle --release  # For Google Play
```

## Production Checklist

### 🔒 Security
- [ ] Remove debug prints
- [ ] Validate user inputs
- [ ] Use HTTPS for backend
- [ ] Rate limit backend API
- [ ] Enable ProGuard (Android)

### 📊 Analytics (Optional)
- [ ] Firebase Analytics setup
- [ ] Crashlytics integration
- [ ] Performance monitoring

### 📝 App Store Preparation

#### iOS App Store
- [ ] App Store Connect account created
- [ ] App created in App Store Connect
- [ ] Screenshots prepared (multiple device sizes)
- [ ] App description written
- [ ] Keywords optimized
- [ ] Privacy policy URL (if collecting data)
- [ ] Support URL
- [ ] Age rating selected
- [ ] TestFlight beta testing completed

#### Google Play Store
- [ ] Google Play Console account created
- [ ] App created in Play Console
- [ ] Screenshots prepared (phone, tablet, 7-inch tablet)
- [ ] Feature graphic (1024x500)
- [ ] App description written
- [ ] Privacy policy URL
- [ ] Content rating questionnaire completed
- [ ] Internal testing track deployed
- [ ] Closed/open beta testing completed

## Final Pre-Launch

### 🧪 Testing
- [ ] Test on multiple device sizes
- [ ] Test on both iOS and Android
- [ ] Test notification permissions flow
- [ ] Test with no network (offline behavior)
- [ ] Test contest fetching with backend
- [ ] Test streak logic across midnight
- [ ] Test with fresh install (no cached data)
- [ ] Test all navigation flows
- [ ] Test statistics with various data

### 📱 Device Testing Matrix
- [ ] iPhone (iOS latest)
- [ ] iPhone (iOS -1 version)
- [ ] iPad
- [ ] Android phone (latest)
- [ ] Android phone (older version)
- [ ] Android tablet

### 🎨 UI/UX Review
- [ ] All text readable
- [ ] Colors accessible (contrast ratio)
- [ ] Buttons touchable (minimum 44x44 pts)
- [ ] Loading states shown
- [ ] Error states handled gracefully
- [ ] Empty states informative
- [ ] Animations smooth

## Backend Deployment

### ✅ Backend Checklist
- [ ] Environment variables configured
- [ ] CORS enabled for production domain
- [ ] Rate limiting implemented
- [ ] Error logging setup
- [ ] Monitoring enabled
- [ ] CDN configured (if needed)
- [ ] Database backups (if using one)
- [ ] SSL certificate valid

### 🌐 Backend Providers (Choose One)

#### Vercel (Recommended for reference backend)
```bash
cd backend
vercel --prod
```
- [ ] Custom domain configured
- [ ] Environment variables set

#### Heroku
```bash
git push heroku main
```
- [ ] Dyno type selected
- [ ] Add-ons configured
- [ ] Config vars set

#### AWS Lambda
- [ ] API Gateway configured
- [ ] Lambda function deployed
- [ ] CloudWatch logs enabled

#### DigitalOcean
- [ ] App spec configured
- [ ] Environment variables set
- [ ] Domain pointed

## Post-Launch

### 📊 Monitoring
- [ ] Set up app crash tracking
- [ ] Monitor backend API health
- [ ] Track user engagement metrics
- [ ] Watch for reviews/feedback

### 🔄 Updates
- [ ] Version numbering scheme decided
- [ ] Update mechanism tested
- [ ] Release notes template created

### 📢 Marketing (Optional)
- [ ] Landing page created
- [ ] Social media accounts
- [ ] Reddit/HN launch post prepared
- [ ] Email announcement ready

## Version Control

### Git Best Practices
```bash
# Tag release
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0

# Create release branch
git checkout -b release/1.0.0
```

### Release Notes Template
```markdown
## Version 1.0.0 - Initial Release

### Features
- Daily problem tracking with streaks
- Contest notifications
- Statistics & analytics
- Motivational quotes system

### Supported Platforms
- Codeforces, LeetCode, CodeChef, AtCoder, GeeksforGeeks, CodingNinjas

### Known Issues
- None

### Coming Soon
- Cloud sync
- Friend leaderboards
- Dark mode
```

## Emergency Contacts

### If Issues Arise
1. **Backend Down**: Switch to local/backup server
2. **App Crashes**: Check crash logs, roll back if needed
3. **Store Rejection**: Address review feedback, resubmit
4. **User Reports**: Monitor support email/reviews

## Rollback Plan

### If Release Has Issues
```bash
# Revert to previous version
git revert HEAD
flutter build ios/android --release
# Resubmit to stores
```

## Success Metrics

### Week 1 Targets
- [ ] 100 downloads
- [ ] No crashes reported
- [ ] 4+ star average rating
- [ ] Backend uptime >99%

### Month 1 Targets
- [ ] 1,000 downloads
- [ ] Active users using streak feature
- [ ] Positive reviews
- [ ] Backend handling load

## Celebration! 🎉

When all checks complete:
- [ ] App live on iOS App Store
- [ ] App live on Google Play Store
- [ ] Backend stable and monitored
- [ ] User feedback loop established
- [ ] Marketing materials published

---

**You're ready to launch! Remember: shipping is better than perfecting. You can always iterate based on user feedback.**

*Good luck with your launch! 🚀*
