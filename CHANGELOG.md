# Changelog

## 0.5.0 — 2026-10-30

### Removed

- The NeMo Speech server provider is gone: the audio.cpp server runs the same Nemotron 3.5 model, alongside
  Voxtral Realtime, Parakeet and Qwen3-ASR.

### Fixed

- Dictation recovers by itself after the Windows audio system stops responding: the take that hit it says
  so instead of blaming the microphone, and the next take records without restarting SpeechInput. The
  microphone list in Settings shows an error instead of hanging when Windows audio does not answer.
- With Gemini, a take no longer hangs for about 6 seconds before its text is inserted when Gemini never
  confirms the last phrase; the text goes in about 1.5 seconds after Gemini stops sending updates.

## 0.4.2 — 2026-10-25

### Changed

- The transcript card's title bar is now translucent like the rest of the card, with a dimmed title and a smaller close button.
- The transcript card keeps every phrase of the last five minutes instead of only the last three.

## 0.4.1 — 2026-10-25

### Changed

- Phrases on the card now expire after 5 minutes: opening the card shows only recent dictation, or the
  invitation when everything is older.

### Fixed

- With Gemini, releasing the hotkey mid-word no longer sometimes holds the text back for about 6 seconds
  before it is inserted.

## 0.4.0 — 2026-10-23

### Added

- A new provider, **OpenAI-compatible server**, sends each take as a whole recording to any server that
  speaks OpenAI's transcription API: the local [audio.cpp](https://github.com/0xShug0/audio.cpp) server with
  Qwen3-ASR 1.7B, which keeps every word of a minute-long take in Russian and English, or whisper.cpp,
  Speaches, vLLM and OpenAI itself. The text is typed when the server finishes; there is no live text while
  you speak. An optional API key is sent to servers that need one.

### Fixed

- An app several versions behind now updates with small patches, one per missed version, instead of
  downloading the whole ~100 MB package again.
- On first start the recognition languages are taken from your keyboard layouts even when the default
  provider has no language choice, so switching to one that does no longer shows an empty list.
- Opening and closing Settings no longer makes the app use more memory each time, and the app no longer
  crashes after Settings has been opened many times.

## 0.3.0 — 2026-10-18

### Added

- The **audio.cpp server** model is picked from a drop-down that lists the streaming speech recognition
  models the server serves, read when the list is opened. With the server stopped the page still opens
  at once and keeps the model already chosen.
- A second fully local provider, **audio.cpp server**, streams to an
  [audio.cpp](https://github.com/0xShug0/audio.cpp) server you start yourself, running Voxtral Mini 4B
  Realtime. It shows the text live while you speak and keeps Russian and English each in its own alphabet
  within one sentence ("открыл pull request на review"). It detects the language itself, so the
  recognition languages in Settings do not apply to it.
- Clicking the warning mark next to a refused provider setting copies the error text to the clipboard.
- The Gemini model drop-down lists the Live transcription models your API key can use, loaded from Google
  when you open it, so new models appear without an app update. Without a key or a connection it keeps the
  built-in list and says why.
- Setup scripts for the local recognition servers are now published in
  [local-servers](https://github.com/vsDizzy/speech-input/tree/main/local-servers): they download the
  server and its model and start it. The "setup guide" link on the NeMo Speech server and audio.cpp server
  provider pages leads there.
- Dictation can run fully on your own PC: the new **NeMo Speech server** provider streams to a
  [NeMo-Speech.cpp](https://github.com/NVIDIA/NeMo-Speech.cpp) server you start yourself and shows the text
  live while you speak, with no audio going to a cloud service. It detects the spoken language itself, so
  the recognition languages in Settings do not apply to it.
- The **NeMo Speech server** address is set on the provider page of the settings window: type
  `host:port` or a full `ws://` address, or leave it empty for the default `ws://127.0.0.1:8080`.
- A **NeMo Speech server** started with an API key works too: paste the same key into "Server API key" on
  the provider page. A missing or refused key gets its own message with a link to Settings.

### Changed

- The settings window now opens at 800 x 520 and can be resized down to 640 x 400.

### Fixed

- Music paused for dictation now comes back when a new take is started right after the previous one, while
  its stop sound is still playing. Before, the music stayed paused until started by hand.

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
