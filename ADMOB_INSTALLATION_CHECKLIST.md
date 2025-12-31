# AdMob Plugin Installation Checklist

**Status:** Plugin files installed ✅ | Need to configure in Godot ⏳

## ✅ Completed Steps

1. ✅ Downloaded AdMob plugin from GitHub
2. ✅ Extracted to `addons/admob/` folder
3. ✅ Plugin enabled in `project.godot` (line 39)

---

## ⏳ Remaining Steps (Do These Now)

### Step 1: Open Godot
- Launch **Godot 4.x**
- Open the **Tutti Fruttini** project

### Step 2: Install Android Build Template (If Not Already Done)
- Go to **Project → Install Android Build Template**
- Click **"Install"**
- Wait for completion (creates `android/` folder)

### Step 3: Configure Android Export Preset

1. Go to **Project → Export...**

2. **If you don't see "Android" in the list:**
   - Click **"Add..."**
   - Select **"Android"**
   - Click **"Add"**

3. **Select the "Android" preset** from the list

4. **Scroll down to find the "Plugins" section**
   - Look for a checkbox labeled **"AdMob"**
   - **Check the box** ✅
   - If you don't see AdMob listed, the plugin may not be recognized - restart Godot

5. **While you're here, verify these settings:**
   - Package → Unique Name: `com.bonsaidotdot.tuttifruitini`
   - Min SDK: `24`
   - Target SDK: `34`

6. Click **"Close"** to save

### Step 4: Restart Godot (Important!)
- Close Godot completely
- Reopen it and load the project
- This ensures the plugin is fully loaded

### Step 5: Test the Plugin Recognition

1. Open the project in Godot
2. Go to **Output** panel (bottom of screen)
3. Click the **Play button** (F5) to run the game
4. Watch the **Output** panel for this message:
   ```
   AdMob plugin detected
   AdMob initialized in TEST mode...
   ```

**If you see "AdMob plugin not detected":**
- The plugin isn't loading - go back to Step 3 and verify plugins are enabled

**If you see "AdMob plugin detected":**
- ✅ **SUCCESS!** Plugin is working!

### Step 6: Verify Plugin in Android Export

1. Go to **Project → Export...**
2. Select **Android** preset
3. Look for **"Export With Debug"** button at bottom
4. Check that AdMob appears in the enabled plugins list

---

## 🧪 Testing on Android Device (Later)

**After building the APK/AAB:**

1. Install on Android device
2. Play until shakes run out
3. Tap "Refill Shakes" button
4. **Expected behavior:**
   - Google test ad should appear
   - Complete the ad
   - Shake count refills to 50

**If ad doesn't show:**
- Free refill timer starts (30 seconds)
- This means plugin isn't working on device

---

## 🚨 Troubleshooting

### "AdMob not found in Plugins list"
- Restart Godot
- Check `addons/admob/plugin.cfg` exists
- Verify line 39 in `project.godot` has the plugin enabled

### "Plugin detected but ads don't load"
- This is normal in Godot editor (ads only work on device)
- Test on actual Android device after building APK

### "Error loading plugin"
- Make sure you downloaded the **Godot 4.x** version of the plugin
- Godot 3.x plugin won't work with Godot 4.x

---

## ✅ Verification Checklist

Before moving on, verify:

- [ ] Android build template installed (`android/` folder exists)
- [ ] Android export preset created
- [ ] **AdMob plugin checked in export preset plugins**
- [ ] Godot restarted after enabling plugin
- [ ] "AdMob plugin detected" shows in output when running game
- [ ] No error messages in output related to AdMob

---

**Once all boxes are checked, you're ready to build the APK/AAB!**

Next file to use: `ANDROID_BUILD_GUIDE.md` sections 6-7 (keystore and build)
