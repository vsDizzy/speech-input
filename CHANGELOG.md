# Changelog

Settings → About links to this file on the public repository's main branch, where CI publishes it on release.
Do not edit release sections by hand: add a fragment to `.changes/` (see `.changes/README.md`); the
release workflow folds them in.

## 0.1.0 — 2026-10-15

### Added

- Dictation into any app: hold the hotkey (**Ctrl + Shift** by default), speak, release, and the text
  is pasted into the active window.
- Live transcription through provider plugins. The first provider is the Gemini Live API, with a choice
  of model, recognition languages and a custom vocabulary.
- Transcript card with the last three phrases, each with its own Copy button.
- Playing media pauses while you dictate and resumes afterwards.
- Settings: microphone, hotkey, start with Windows, a **Provider** page to pick the transcription
  provider and set it up (for Gemini, an API key from [Google AI Studio](https://aistudio.google.com/)),
  and an About page with the version and links to
  these release notes, the license and the privacy policy.
