# NeMo Speech server in Docker

The [NeMo-Speech.cpp](https://github.com/NVIDIA/NeMo-Speech.cpp) 0.2.0 server from upstream's published
Linux archive, nothing compiled. It mounts the same `../models` as the native setup and listens on
`ws://127.0.0.1:8080`, the provider's default address.

```powershell
../download-model-nemotron.ps1               # models only
docker compose --profile cuda up -d --build  # or cpu / vulkan; COMPOSE_PROFILES in .env does the same
docker compose logs -f
```

Copy `.env.example` to `.env` for the profile, the host port or an API key.

| Profile | GPU | Host |
|---|---|---|
| `cpu` | none | any; on the developer's i7-6700K the final text comes 7–10 s after commit, against 0.15 s on native Vulkan |
| `cuda` | NVIDIA Turing (RTX 20) or newer, driver with CUDA 13 | NVIDIA Container Toolkit, or Docker Desktop on WSL 2 |
| `vulkan` | NVIDIA, also older than Turing | Linux host with the NVIDIA Container Toolkit; on WSL 2 the GPU must support 16-bit shader storage through Direct3D 12 |

Only `cpu` has been run end to end. On the developer's GTX 960 under WSL 2, `cuda` reaches the GPU and
stops at `no kernel image is available`, and `vulkan` reaches it through Mesa's Dozen driver and stops
at `does not support 16-bit storage`. Both are limits of that GPU, so on Windows with a Maxwell or Pascal
card use the native setup. AMD and Intel GPUs on a Linux host need `/dev/dri` added to the `vulkan`
service's `devices` (the image has their drivers).

About one start in three, 0.2.0 aborts during warmup with `GGML_ASSERT(ne3 == ne13)`; the container
restarts on its own.

## Upgrading

The version is pinned in `NEMO_SPEECH_VERSION` in the `Dockerfile` and in the image tags in
`compose.yaml`; keep both in step with `$Version` in `../lib/Download.psm1`.

## Network access

The server speaks plain `ws://` and has no authentication unless `NEMO_SPEECH_HTTP_API_KEY` is set in
`.env`, so the port is published on loopback only. Do not expose it on a shared network without TLS in
front.
