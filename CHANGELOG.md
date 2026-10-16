# Changelog

## 0.2.0 — 2026-10-16

### Changed

- Updating across several versions at once downloads only the changes between them instead of the whole
  app (~100 MB), as long as that is smaller.
- The portable build keeps its settings and logs in a `data` folder next to the app instead of
  `%LocalAppData%\SpeechInput`, so it no longer shares them with an installed copy.

### Fixed

- The end of the last word is no longer cut off when the hotkey is released right after speaking.
- Your clipboard is no longer replaced by the dictated text when you switch windows just before the
  text is pasted, or when placing the text on the clipboard fails.
- When the connection to the transcription service drops partway through a dictation, the words recognized
  before the drop are still typed, and the card now stays up to say that only the start of the dictation was
  typed instead of quietly disappearing.
- Gemini: the last phrase of a dictation is no longer dropped when the answer for an earlier phrase arrives
  late.
- A microphone that cannot be opened (unplugged, held by another app, or blocked in the Windows privacy
  settings) now shows an error on the card instead of the dictation quietly ending as if nothing was said.
  A microphone lost in the middle of a dictation is reported at once.
- Pressing the hotkey while the previous dictation is still being finished is no longer ignored: the new
  dictation starts as soon as the previous one is done, announced by the usual start sound.

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
