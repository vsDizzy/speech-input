# Speech Input — Privacy Policy

Speech Input does not collect, store on any server, sell, or share any information about you. There are no accounts, analytics, telemetry, advertising, or tracking of any kind. The author of Speech Input never receives any of your data.

## What stays on your computer

- **Settings** are stored in `%LocalAppData%\SpeechInput\data\settings.json`.
- **Your Gemini API key** is stored in the Windows Credential Locker (`PasswordVault`), which is protected by your Windows account. If the Credential Locker is unavailable, the key is stored in a file encrypted with Windows DPAPI for your user account.
- **Diagnostics.** If the app crashes, it writes a report to `%LocalAppData%\SpeechInput\data\crash.log`. The report contains only technical details such as error messages and recent app events. It does not contain your recordings or recognized text. The report is never sent anywhere; you can read or delete it at any time.

Audio from your microphone is processed in memory only while you dictate and is never saved to disk.

## What is sent to Google

Speech recognition is performed by Google Gemini. While you dictate, Speech Input sends the following directly from your computer to Google's Gemini API, using the API key you provided:

- the audio of your dictation;
- the recognition settings for that request: the selected languages and your custom vocabulary.

Speech Input has no servers of its own, so this data never passes through the author. Google processes it under its own terms and privacy policy, which depend on the type of API key and plan you use:

- [Gemini API Additional Terms of Service](https://ai.google.dev/gemini-api/terms)
- [Google Privacy Policy](https://policies.google.com/privacy)

Nothing is sent to Google unless you start dictation.

## GDPR

Speech Input is designed to follow the principles of the EU General Data Protection Regulation (GDPR), such as data minimisation and privacy by design. The author does not collect or process any of your personal data, so there is nothing to request, correct, or delete on the author's side. All locally stored data is under your control and is removed when you uninstall the app and delete `%LocalAppData%\SpeechInput`.

Speech Input has not undergone any formal GDPR certification.

## Changes

If this policy changes, the updated version will be published with the release that introduces the change.
