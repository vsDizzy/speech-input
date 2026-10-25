# Speech Input

Dictation into any Windows app: hold a hotkey, speak, release — the text is pasted into the active window.
Speech is recognized by a provider chosen in Settings, such as the Gemini Live API. The app lives in the
system tray and has no main window.

## Features

- **Hold-to-talk hotkey.** Default is Ctrl + Shift; a single key or a chord of up to three keys can be
  recorded in Settings, and left/right modifiers are told apart.
- **Live transcript card.** A small acrylic card shows the text while you speak and keeps the phrases
  of the last five minutes with a Copy button each.
- **Pastes into the focused app.** Uses the clipboard and Ctrl+V, then restores the previous clipboard.
- **Quiet room.** Media that is playing pauses while you dictate and resumes afterwards.
- **Echo cancellation.** Uses the Windows audio engine, so audio playing on your speakers is not transcribed.
- **Recognition languages.** Defaults to your keyboard layouts; 84 languages are available.
- **Custom vocabulary.** Words the recognizer should know.
- **Microphone choice.** If the selected device is unplugged, the default one is used until it comes back.
- **Light and dark theme.** Follows Windows.

## Requirements

- Windows 10 1809 or later, x64
- A [Gemini API key](https://aistudio.google.com/apikey), or another provider set up in Settings → Provider

## Recognition on your own PC

The NeMo Speech server and audio.cpp server providers send audio to a recognition server you run
yourself, so nothing leaves your network. [local-servers](local-servers/README.md) has a setup for each:
scripts that download the server and its model, and how to start it.

## License

Proprietary, see [LICENSE.md](LICENSE.md). Privacy: [PRIVACY.md](PRIVACY.md).
