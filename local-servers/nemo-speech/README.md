# NeMo Speech server

A local [NeMo-Speech.cpp](https://github.com/NVIDIA/NeMo-Speech.cpp) 0.2.0 server with the Nemotron 3.5
ASR Streaming model, for the app's **NeMo Speech server** provider. Binaries and models are downloaded from
upstream's published releases, never built and never committed (`.gitignore`). The server listens on
`ws://127.0.0.1:8080`, the provider's default address.

```powershell
./download-vulkan.ps1           # runtime/vulkan
./download-model-nemotron.ps1   # models/nemotron-3.5-asr-streaming-0.6b.q8_0.gguf (~740 MB)
./serve-vulkan.ps1
```

Vulkan runs on any GPU with a Vulkan driver, Maxwell (GTX 900) included. `download-cuda.ps1` /
`serve-cuda.ps1` are upstream's CUDA 13 build: Turing (RTX 20) or newer; not run here. The serve
parameters are in `lib/serve.ps1`.

About one start in three, 0.2.0 aborts during warmup with `GGML_ASSERT(ne3 == ne13)`; starting it again
helps.

## Upgrading

The version is `$Version` in `lib/Download.psm1`. The model revision and hash in
`download-model-nemotron.ps1` come from that release's `share/nemo-speech/model-index.json`.

## Network access

The server speaks plain `ws://` and has no authentication unless `NEMO_SPEECH_HTTP_API_KEY` is set, so
the serve scripts bind to loopback only. Do not expose it on a shared network without TLS in front.
