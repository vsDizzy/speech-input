# audio.cpp server

A local [audio.cpp](https://github.com/0xShug0/audio.cpp) 0.9.2 server for the app's **audio.cpp server**
provider, with any of Voxtral Mini 4B Realtime, Nemotron 3.5 ASR Streaming 0.6B and Confucius4-R2T2. The
runtime and models are downloaded from upstream's published release and Hugging Face, pinned by SHA-256,
never committed (`.gitignore`). The server listens on `http://127.0.0.1:8081`, the provider's default
address.

```powershell
./download-vulkan.ps1            # runtime/vulkan
./download-model-voxtral.ps1     # models/voxtral-mini-4b-realtime-2602-q4_k.gguf (~3.1 GB)
./download-model-nemotron.ps1    # models/nemotron-3.5-asr-streaming-0.6b-q8_0.gguf (~0.9 GB)
./download-model-confucius.ps1   # models/confucius4-r2t2-q8_0.gguf (~2.5 GB)
./serve-vulkan.ps1
```

`download-*` scripts without `model` fetch a runtime, `serve-*` runs it. Vulkan runs on any GPU with a
Vulkan driver, Maxwell (GTX 900) included. `download-cuda.ps1` / `serve-cuda.ps1` are upstream's CUDA 13.3
build with its CUDA DLLs (~850 MB): Turing (RTX 20) or newer; not run here.

The server serves every model found in `models/`: Voxtral as `voxtral-realtime` (the provider's default
model id), Nemotron as `nemotron-asr`, the same model the NeMo Speech server runs, and Confucius4-R2T2 as
`confucius-r2t2`. The app lists them from `/v1/models` and the client picks one per request. Only one
model stays in memory: the first request after a switch waits for the other to load (a few seconds on a
GTX 960). [MODELS.md](MODELS.md) has the test notes for these and for the models tried and dropped.

`./download-model-voxtral.ps1 -Model q8_0` is the 5.1 GB package, which streams in about 9 GB;
`./download-model-nemotron.ps1 -Model f16` is ~1.3 GB. When both packages of a model are downloaded, pick
one with `-VoxtralModel q8_0` / `-NemotronModel f16`; the serve parameters are in `lib/serve.ps1`.

On a GTX 960 (4 GB) Voxtral q4_k uses 3.7 GB of VRAM together with the desktop and decodes at ~78 ms per
80 ms step: real time, with no headroom for anything else on the GPU.

Confucius4-R2T2 is NetEase Youdao's streaming fine-tune of Qwen3-ASR 1.7B, under the NetEase Youdao Model
Use License. On a GTX 960 it keeps up with real time only at `-ConfuciusChunkMs 2000`, the serve default.

The serve scripts write `runtime/server.json` on every start. To serve other models, write a config by
hand (`app/server/README.md` upstream) and run `runtime/<backend>/audiocpp_server.exe --config <file>`.

## Upgrading

The runtime version and archive hashes (the release's asset digests) are in `lib/Download.psm1`; each
model's Hugging Face revision and hashes are in its `download-model-*.ps1`.

## Network access

The server speaks plain HTTP with no authentication, so the serve scripts bind to loopback. Do not expose
it on a shared network.
