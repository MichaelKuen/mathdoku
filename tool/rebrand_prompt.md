# Rebrand Prompt — Flutter App

Use this prompt when setting up a new Flutter project with the correct company identity.
Fill in the four variables at the top, then paste the whole thing into Claude Code.

---

## Variables

| Variable | Value |
|---|---|
| **Company display name** | App Verse Games |
| **Bundle org segment** | appversegames |
| **Contact email** | play@appversegames.com |
| **Website** | https://appversegames.com |

---

## Prompt (copy from here)

```
Please update this Flutter project with the correct company branding. Here are the details:

- Company name:   App Verse Games
- Bundle org:     appversegames  (bundle IDs should follow the pattern com.appversegames.<appname>)
- Contact email:  play@appversegames.com
- Website:        https://appversegames.com

Do all of the following:

1. COPYRIGHT HEADERS
   Replace the existing company name in the copyright header comment at the top of every .dart file
   with "App Verse Games".

2. BUNDLE / APPLICATION ID
   Update the bundle or application ID on every platform to com.appversegames.<appname>:
   - android/app/build.gradle.kts         → namespace and applicationId
   - android/app/src/main/kotlin/…/MainActivity.kt → package declaration; move the file to
     the matching directory (com/appversegames/<appname>/) and delete the old directory
   - ios/Runner.xcodeproj/project.pbxproj → all PRODUCT_BUNDLE_IDENTIFIER entries
   - macos/Runner.xcodeproj/project.pbxproj → all PRODUCT_BUNDLE_IDENTIFIER entries
   - macos/Runner/Configs/AppInfo.xcconfig → PRODUCT_BUNDLE_IDENTIFIER and PRODUCT_COPYRIGHT
   - linux/CMakeLists.txt                 → APPLICATION_ID
   - windows/runner/Runner.rc             → CompanyName, LegalCopyright, ProductName, FileDescription

3. UI / IN-APP TEXT
   Search all .dart files for the old company name and replace every user-visible occurrence
   (sheet titles, footer text, "about" sections, etc.) with "App Verse Games".

4. EMAIL
   Replace all occurrences of the old contact/privacy email with play@appversegames.com.
   This includes mailto: links and plain text in the privacy policy.

5. WEBSITE & STORE LINKS
   - Update any website URL references to https://appversegames.com
   - Update any Google Play developer link to use the new org name
   - Update any Play Store app package IDs that use the old org segment to com.appversegames.*

6. WEB METADATA
   - web/index.html  → <title> and og:title tags
   - web/manifest.json → "name" field
   - Add <meta property="og:url"> pointing to https://appversegames.com if not present

7. WINDOWS METADATA (windows/runner/Runner.rc)
   - CompanyName    → "App Verse Games"
   - LegalCopyright → "Copyright (C) <year> App Verse Games. All rights reserved."
   - ProductName and FileDescription → proper-cased app name (not lowercase)

8. MACOS COPYRIGHT (macos/Runner/Configs/AppInfo.xcconfig)
   - PRODUCT_COPYRIGHT → "Copyright © <year> App Verse Games. All rights reserved."

9. ANDROID APP LABEL (android/app/src/main/AndroidManifest.xml)
   - android:label → use the proper-cased app name (not lowercase)

After making all changes, do a final search for the old company name, old bundle org segment,
and old email across lib/, web/, android/, ios/, macos/, linux/, and windows/ to confirm
nothing was missed (binary and lock files can be ignored).
```

---

## Notes for future projects

- For Play Store links, use `AppVerseGames` as the developer ID until the account name is confirmed.
- The Google Play developer ID in store URLs must match the exact name on the Play Console account.
- If the project uses `google_fonts`, consider bundling the font as a Flutter asset and removing
  the package to avoid CDN fetches on web (see the Sudoku project for the pattern).
- When deploying to a subdirectory on the web host, always build with:
    flutter build web --release --base-href /<folder-name>/
  Without this, all assets resolve to the domain root and the page loads blank.
- The web/.htaccess must include `AddType text/javascript .mjs` for WASM builds to work.
