# Local servers

Recognition servers that Speech Input's local providers connect to, set up to run on your own PC. Each
folder is self-contained: scripts that download the server and its model from upstream (pinned by
SHA-256) and start it, and a container build where upstream offers none that fits. Download the folder
you need and run its scripts in PowerShell 7 from inside it.

- [`nemo-speech/`](nemo-speech/README.md) — NeMo-Speech.cpp with Nemotron 3.5, for the NeMo Speech server
  provider.
- [`audio-cpp/`](audio-cpp/README.md) — audio.cpp with Voxtral Mini 4B Realtime, for the audio.cpp server
  provider.
