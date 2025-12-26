# AdMob Plugin Setup Guide

This guide explains how to install and configure the AdMob plugin for Tutti Fruitini.

## Prerequisites

- Godot 4.2+ installed
- Android SDK configured (for building to Android)
- Google AdMob account with App ID

## Installation Steps

### 1. Download AdMob Plugin

Download the **Poing Studios Godot AdMob Plugin** (v6.0+):
- GitHub: https://github.com/Poing-Studios/godot-admob-plugin
- Or install from Godot Asset Library: Search for "AdMob"

### 2. Install Plugin

**Option A: Manual Installation**
1. Download the latest release from GitHub
2. Extract the `admob` folder
3. Copy it to `res://addons/admob/` in your project
4. Restart Godot

**Option B: Asset Library**
1. Open Godot Editor
2. Go to AssetLib tab
3. Search for "AdMob"
4. Download and install
5. Restart Godot

### 3. Enable Plugin

1. In Godot, go to **Project → Project Settings**
2. Navigate to the **Plugins** tab
3. Find "AdMob" and enable it

### 4. Configure AdMob IDs

#### Current Setup:
The game has **both Test and Production IDs** configured in `scripts/autoload/AdManager.gd`.

**Production IDs (Tutti Fruitini)**:
- App ID: `ca-app-pub-2547513308278750~1856760076`
- Rewarded Ad ID: `ca-app-pub-2547513308278750/3568656364`

**Test IDs** (Google's test ads):
- App ID: `ca-app-pub-3940256099942544~3347511713`
- Rewarded Ad ID: `ca-app-pub-3940256099942544/5224354917`

#### Switching Between Test and Production:

In `scripts/autoload/AdManager.gd`, toggle this constant:

```gdscript
# Set to true for development (test ads)
# Set to false for production (real ads)
const USE_TEST_ADS: bool = true
```

**IMPORTANT**:
- ✅ **Development/Testing**: Set `USE_TEST_ADS = true`
- ❌ **Release Build**: Set `USE_TEST_ADS = false` before building APK/AAB
- Test ads don't generate revenue and are for testing only
- Production ads require AdMob account approval

### 5. Update AndroidManifest.xml

Add your AdMob App ID to the Android manifest.

**For Production Release**, use:
```xml
<application>
    <!-- AdMob App ID (PRODUCTION) -->
    <meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="ca-app-pub-2547513308278750~1856760076"/>
</application>
```

**For Testing**, you can use the test App ID:
```xml
<application>
    <!-- AdMob App ID (TEST) -->
    <meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="ca-app-pub-3940256099942544~3347511713"/>
</application>
```

Location: `android/build/AndroidManifest.xml`

### 6. Configure Android Export

1. Go to **Project → Export**
2. Select your Android export preset
3. Under **Plugins**, ensure AdMob is enabled
4. Add permissions:
   - `INTERNET`
   - `ACCESS_NETWORK_STATE`

## Current Implementation

### AdManager Features

The `AdManager.gd` autoload provides:
- ✅ Rewarded ad loading and display
- ✅ Automatic retry on ad load failure
- ✅ Graceful fallback if plugin not available
- ✅ Free shake refill fallback (30s cooldown)
- ✅ Integration with ShakeManager

### Usage in Game

When shake count reaches 0:
1. Refill button appears
2. Player taps refill button
3. AdManager shows rewarded ad
4. On completion, shake count refilled to 50
5. If ad fails, free refill offered after 30s

## Testing

### Test Rewarded Ads

1. Build and run on Android device
2. Use all shakes (tap Shake button 50 times)
3. Tap "Refill Shakes" button
4. Google test ad should appear
5. Complete the ad
6. Verify shake count refills to 50

### Debug Output

Check console for AdMob debug messages:
- `"AdMob plugin detected"`
- `"Rewarded ad loaded"`
- `"User earned reward"`
- `"Rewarded ad failed to load: [error_code]"`

## Troubleshooting

### "AdMob plugin not detected"
- Ensure plugin is installed in `res://addons/admob/`
- Plugin is enabled in Project Settings → Plugins
- Restart Godot after installation

### "Ad failed to load"
- Check internet connection
- Verify Ad Unit ID is correct
- Test IDs only work on physical devices (not emulator)
- Check AdMob dashboard for account status

### Ads not showing
- Ensure you're testing on a real Android device
- Check Android permissions are set correctly
- Verify AndroidManifest.xml has correct App ID
- Wait a few minutes after first setup (ad inventory may be empty)

## Privacy & GDPR

For EU users, you must:
1. Show consent dialog (AdMob includes consent SDK)
2. Allow users to opt-out of personalized ads
3. Include privacy policy URL in Play Store listing

See `PRIVACY_POLICY.md` for template.

## Production Checklist

Before releasing:
- [ ] **Set `USE_TEST_ADS = false` in AdManager.gd**
- [ ] Update AndroidManifest.xml with production App ID
- [ ] Verify production ad IDs are correct in AdManager.gd
- [ ] Test on multiple Android devices
- [ ] Verify ads load and reward correctly
- [ ] Ensure AdMob account is approved and ads enabled
- [ ] Implement GDPR consent (if targeting EU)
- [ ] Add privacy policy to app and Play Store
- [ ] Monitor AdMob dashboard for impressions

## Resources

- AdMob Plugin Docs: https://github.com/Poing-Studios/godot-admob-plugin/wiki
- Google AdMob Help: https://support.google.com/admob
- Test Ads Guide: https://developers.google.com/admob/android/test-ads
