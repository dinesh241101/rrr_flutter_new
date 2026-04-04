# RRR Flutter App - Setup Instructions

## Quick Start Guide

### Prerequisites
- Flutter SDK (3.11.4 or higher)
- Dart (included with Flutter)
- Android Studio or Xcode for emulator/device testing
- Git

### Step 1: Clone and Install Dependencies

```bash
# Navigate to project directory
cd ~/Documents/projects/rrr_flutter_new

# Get all dependencies
flutter pub get

# (Optional) Generate any necessary code
flutter pub run build_runner build
```

### Step 2: Verify Supabase Integration

The app is already configured with Supabase. To verify:

1. Check `lib/core/supabase_client.dart` for configuration
2. Ensure internet connectivity is available
3. Supabase URL: `https://xbbxhkemzrmdsyyclgya.supabase.co`

### Step 3: Run the App

**On Emulator/Simulator:**
```bash
# Start an emulator first
flutter emulators launch <emulator_name>

# Run the app
flutter run
```

**On Physical Device:**
```bash
# Connect device and enable USB debugging
# Then run:
flutter run
```

### Step 4: Test the App

#### Test Navigation Flow:
1. App opens with Splash Screen
2. Redirects to Login Screen (enter any credentials)
3. Goes to Home Screen with featured games
4. Try hamburger menu (top-left) to open drawer
5. Click coins display to view transaction history
6. Navigate to Games tab - toggle between list/tile view
7. Navigate to Quizistan - toggle between list/tile view and see quizzes from Supabase
8. Navigate to Tournament view

#### Test API Integration:
1. Coins Transaction Screen fetches from `coin_transactions` table
2. Game Scores fetched from `game_scores` table
3. Quizistan quizzes fetched from `quizistan_quizzes` table
4. Tournament data from `tournament_participants` table

## File Structure Overview

```
lib/
├── core/
│   ├── supabase_client.dart          # Supabase initialization
│   ├── responsive_helper.dart         # Responsive utilities
│   ├── app.dart                       # Main app widget
│   ├── constants/
│   │   ├── app_assets.dart
│   │   ├── app_strings.dart
│   │   └── app_values.dart
│   └── ...
├── models/
│   ├── supabase_models.dart          # Database models
│   ├── game_mode.dart
│   ├── leaderboard_entry.dart
│   └── ...
├── providers/
│   ├── profile_provider.dart          # User profile state
│   ├── wallet_provider.dart
│   ├── session_provider.dart
│   ├── tournament_provider.dart
│   └── ...
├── services/
│   ├── games_repository.dart          # Games API calls
│   ├── coins_repository.dart          # Coins API calls
│   ├── quizistan_repository.dart      # Quizistan API calls
│   ├── tournament_repository.dart     # Tournament API calls
│   ├── ads_service.dart
│   └── ...
├── screens/
│   ├── app_shell.dart                 # Main container with navigation
│   ├── coins_transaction_screen.dart  # New: Coin history
│   ├── game_scores_screen.dart        # New: Game scores
│   ├── home/
│   │   └── home_screen.dart
│   ├── games/
│   │   ├── games_screen.dart          # Updated: With list/tile toggle
│   │   └── game_play_screen.dart
│   ├── quizistan/
│   │   └── quizistan_screen.dart      # Updated: With Supabase integration
│   ├── tournament/
│   │   └── tournament_screen.dart
│   ├── login/
│   │   └── login_screen.dart
│   └── ...
├── widgets/
│   ├── responsive_button.dart         # New: Responsive buttons
│   ├── responsive_text.dart           # New: Responsive text
│   ├── game_cards.dart                # New: Game list/tile cards
│   ├── app_drawer.dart
│   ├── coin_balance_chip.dart
│   └── ...
├── data/
│   ├── mock_games.dart
│   └── ...
└── main.dart                          # Updated: With Supabase init
```

## Important Configuration Files

### pubspec.yaml
Located at: `/home/dinesh/Documents/projects/rrr_flutter_new/pubspec.yaml`

**New Dependencies Added:**
```yaml
supabase_flutter: ^1.10.0
responsive_sizer: ^3.2.0
```

### Supabase Configuration
Located at: `lib/core/supabase_client.dart`

**Current Settings:**
- URL: https://xbbxhkemzrmdsyyclgya.supabase.co
- API Key: sb_publishable_fTjFumSU_n7cDxB8wrORpw_J9S10QP_

⚠️ **IMPORTANT**: In production, use environment variables or a separate config file. Never hardcode secrets in version control.

## API Endpoints Summary

### Games
- `GamesRepository.getUserGameScores()` - Fetch user game scores
- `GamesRepository.submitGameScore()` - Submit new game score
- `GamesRepository.getTopGameScores()` - Get leaderboard

### Coins
- `CoinsRepository.getUserTransactions()` - Get transaction history
- `CoinsRepository.getUserCoinBalance()` - Current balance
- `CoinsRepository.addCoinTransaction()` - Record transaction

### Quizistan
- `QuizistanRepository.getActiveQuizzes()` - Browse quizzes
- `QuizistanRepository.getQuizzesByGenre()` - Filter by genre
- `QuizistanRepository.submitQuizAttempt()` - Save quiz result

### Tournament
- `TournamentRepository.getTopTournamentPlayers()` - Leaderboard
- `TournamentRepository.joinTournament()` - Join tournament
- `TournamentRepository.submitTournamentScore()` - Submit score

## Troubleshooting

### Build Issues
```bash
# Clean build files
flutter clean

# Get dependencies again
flutter pub get

# Run build runner (if needed)
flutter pub run build_runner build
```

### Network Issues
- Check internet connection
- Verify Supabase URL is accessible
- Check Supabase project status in dashboard
- Review Supabase RLS (Row Level Security) policies

### Emulator Issues
```bash
# Kill all dart processes
killall dart

# Kill emulator
adb devices
adb -s <device_id> emu kill

# Start fresh
flutter emulators launch <emulator_name>
flutter run
```

### Plugin Issues
```bash
# Get platform packages
cd android
./gradlew clean

cd ios
pod deintegrate
pod install
cd ../..

flutter pub get
```

## Development Workflow

### Making Changes
1. Create a new branch for features: `git checkout -b feature/your-feature`
2. Make changes to relevant files
3. Test thoroughly on multiple screen sizes
4. Commit with clear messages: `git commit -m "feat: add new feature"`

### Hot Reload
- Save file → Hot reload automatically (if using `flutter run`)
- Press 'r' in terminal to hot reload
- Press 'R' to hot restart

### Building Release
```bash
# Build APK
flutter build apk

# Build App Bundle (for Play Store)
flutter build appbundle

# Build iOS
flutter build ios
```

## Testing Responsive Design

### Screen Sizes to Test:
- **Mobile**: 390x844 (iPhone 14)
- **Mobile**: 412x915 (Pixel 6)
- **Tablet**: 1024x1366 (iPad)
- **Desktop**: 1920x1080 (Monitor)

### In Emulator:
1. Go to Extended controls
2. Virtual sensors settings
3. Rotate device or adjust resolution

## Performance Tips

1. Use `flutter run --profile` for performance profiling
2. Check frame rendering time in DevTools
3. Limit list view item count with pagination
4. Cache images using `Image.asset` or cached_network_image
5. Avoid rebuilds using `const` constructors

## Next Steps

1. **Authentication**: Implement Supabase Auth for real login
2. **Push Notifications**: Add Firebase Cloud Messaging
3. **Analytics**: Integrate Firebase Analytics
4. **Error Logging**: Add Sentry or similar service
5. **Offline Support**: Add Hive or Drift for local caching

## Documentation

- **Implementation Guide**: See `IMPLEMENTATION_GUIDE.md` for detailed API usage
- **Flutter Docs**: https://flutter.dev/docs
- **Supabase Docs**: https://supabase.com/docs
- **Provider Pattern**: https://pub.dev/packages/provider

## Support

For issues or questions:
1. Check the error message carefully
2. Review implementation guide
3. Check Supabase dashboard for data
4. Review network logs in DevTools
5. Enable verbose logging: `flutter run -v`

## Deployment Checklist

- [ ] Remove debug logs
- [ ] Update app version in pubspec.yaml
- [ ] Test on real devices
- [ ] Check API rate limits
- [ ] Verify Supabase security policies
- [ ] Update privacy policy
- [ ] Build release versions
- [ ] Test release build on device
- [ ] Submit to store

---

**Last Updated**: 2026-04-04
**Ready for Development**: ✅
