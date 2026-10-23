# audio.cpp models: test notes

What we tried for live dictation through the app's **audio.cpp server** provider and for whole recordings
through the OpenAI-style endpoint, and why a model was kept or dropped. Add a section for every model checked, kept or not, so it is not tried again blindly.

## How a model is checked

- GPU: GTX 960, 4 GB, Vulkan runtime; the model must fit in VRAM next to the desktop.
- Audio: ~14 s phrases synthesized by Windows TTS (an English and a Russian voice), streamed to
  `/v1/audio/transcriptions/live` in real time as 100 ms PCM16 chunks, then about 1 s of silence.
- Measured: when text arrives, how far it falls behind the audio, the final text; then the user tries it
  live with a microphone in the app.
- Baseline: `nemotron-asr` gives words every ~0.3 s and the exact final text right after speech ends.

## Kept

### Nemotron 3.5 ASR Streaming 0.6B (`nemotron-asr`), q8_0

The baseline above: cache-aware streaming, words as they are spoken, Russian and English without errors.

### Voxtral Mini 4B Realtime (`voxtral-realtime`), q4_k

Natively streaming. 3.7 GB of VRAM with the desktop, ~78 ms per 80 ms step: real time with no headroom.

### Confucius4-R2T2 (`confucius-r2t2`), q8_0, 2.5 GB

NetEase Youdao's streaming fine-tune of Qwen3-ASR 1.7B (stable-prefix streaming). Accurate in both
languages, no words lost between steps. Speed depends on the step (`-ConfuciusChunkMs`):

| Step | Keeps up | Final after speech ends |
|---|---|---|
| 320 ms (upstream default) | no, ~3-4x slower than real time | ~55 s |
| 1000 ms | no, ~0.4 s behind per second of speech | ~8 s |
| 2000 ms (serve default) | yes, text every ~2.5 s | ~3 s |

### Parakeet TDT 0.6B v3 (`parakeet`), q8_0, 0.9 GB

Buffered streaming: each step re-encodes 10 s of past audio, the step and a lookahead, so text comes every
step, step + lookahead after it was spoken. Final ~2.5 s after speech ends (with the 1 s of tail silence).
Accurate in both languages; in English-based mixed sentences it keeps English in Latin script ("Let's
kiddle a meeting на завтра в три часа. If that works for you."), which Nemotron does not; English terms
inside Russian come out in Latin too ("build fails on CI", "pull request на review").

| Step / lookahead | Keeps up | Text behind speech | Errors on the TTS set |
|---|---|---|---|
| 2 s / 2 s (upstream default) | yes | ~4 s | none on en/ru-short and ru-long |
| 1 s / 1 s (serve default) | yes | ~2 s | a few: "punch punctuation", "Квинн", a lost comma |
| 1 s / 2 s | no, 27 s behind after 44 s | | |

Live with a microphone: recognizes well, but holds on to one language within a take more than
`parakeet-offline`, which switches between Russian and English freely.

## Kept offline

For whole recordings sent once to `/v1/audio/transcriptions`, the OpenAI-style endpoint: no live text.
Checked with the same TTS voices, ~10 s and 44 s / 61 s recordings (two and three 30 s windows).

### Qwen3-ASR 1.7B (`qwen3-asr`), q8_0, 2.5 GB, `audio_chunk_mode: vad`

Accurate in both languages, ~0.35 real-time factor on a GTX 960: 61 s of Russian in ~24 s, 10 s in ~3.5 s
(plus a few seconds to load after a model switch). How the recording is split (`-QwenChunkMode`):

| Mode | Result |
|---|---|
| `vad` (serve default) | no words lost; at most a stray period where Silero cut a sentence |
| `fixed` (30 s windows) | a phrase repeated at one window edge ("API. Compatible endpoint"), a stray period at another |
| `none` | fails on a 4 GB GPU above ~40 s: "prefill graph does not fit in device memory" |

`stream=true` on an offline model is HTTP 500 ("requires a model configured with mode=streaming"), not a
plain JSON answer, so a client cannot send it unconditionally.

### Parakeet TDT 0.6B v3 (`parakeet-offline`), q8_0, 0.9 GB

The same file as the streaming entry. Accurate in both languages (only names: "Quen", "опеной"), and much
faster than Qwen3-ASR while the whole recording is encoded at once (`offline_mode: full_context`): 10 s in
0.5–0.8 s, 61 s in 3.9 s, 121 s in 7.5 s. At 182 s that fails on a 4 GB GPU ("Failed to allocate Parakeet
TDT encoder position graph tensors"), so serve uses `offline_mode: auto` with a 120 s threshold; above it
the bounded windows run at ~0.35 real time (182 s in 63 s, the end of the text intact).

## Dropped

### Qwen3-ASR 1.7B (`qwen3_asr`) for live dictation, q8_0, 2.5 GB

Kept offline above. Not a streaming model: the server transcribes fixed windows (`audio_chunk_duration_sec`, 30 s by default)
independently. At 2 s windows text comes every ~2 s, but words cut by a window edge are misheard or lost
("распределения. / познавания"); at 5 s fewer are, but the first text comes after ~9 s and words are still
lost at edges.

### VibeVoice ASR Streaming 1.5B (`vibevoice_asr_streaming`), q4_k, 2.1 GB

The only package that fits 4 GB (1.5B q8_0 is 3.3 GB, 7B starts at 5.9 GB); the 1.5B GGUF is a community
upload. Keeps up with real time, text every ~3 s. Weak recognition, Russian especially ("по тока-выборам с
познаваниями"), confirmed live with a microphone. Its output carries diarization and event tags the app
would have to strip: `\n Speaker 0:` before chunks, `[Silence]`, noise markers.

## Not tried yet

Russian-capable ASR models in the runtime's `model_specs/`:

- GigaAM (`gigaam_asr`): Russian-first, offline only; a candidate for the offline endpoint.
- SenseVoice Small (`sense_asr`): very fast; streams fixed windows like Qwen3-ASR, so likely the same
  edge problem.

## audio.cpp facts learned along the way

- A model's `capabilities` lists only `partial_results`, `word_timestamps`, `vad_chunking`, `segments`,
  `speaker_turns`; there is no hotword flag. Prompt support shows only as a `context` request option in the
  model's spec, and `/v1/models` exposes neither.
- The app sends no request options, so a model's request options can only be set per model in the server
  config as `default_request_options`; session options go in `session_options` with the family prefix
  (`confucius4_r2t2.chunk_size_ms`).
