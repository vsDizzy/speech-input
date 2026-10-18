# NeMo-Speech.cpp ASR server from a published Linux release archive; nothing is compiled.
# BACKEND picks the archive: cpu, vulkan, or cuda (CUDA 13, Turing/RTX 20 or newer).
#
# Arch is the base because its vulkan-dzn package is Mesa's Dozen driver (Vulkan over Direct3D 12),
# the only way a container under Docker Desktop / WSL 2 reaches the GPU through Vulkan; Ubuntu's and
# Fedora's Mesa builds leave it out and fall back to the llvmpipe software renderer.

FROM archlinux:base

ARG NEMO_SPEECH_VERSION=0.2.0
ARG BACKEND=cpu

# Vulkan drivers: dzn for WSL 2, radeon/intel for AMD and Intel on a Linux host. The NVIDIA
# driver's own Vulkan ICD is injected by the NVIDIA container runtime.
RUN set -eu; \
    packages="ca-certificates curl"; \
    case "$BACKEND" in \
      cpu|cuda) ;; \
      vulkan) packages="$packages vulkan-icd-loader vulkan-dzn vulkan-radeon vulkan-intel" ;; \
      *) echo "BACKEND must be cpu, vulkan or cuda" >&2; exit 1 ;; \
    esac; \
    pacman -Syu --noconfirm --needed $packages; \
    pacman -Scc --noconfirm

RUN set -eu; \
    name="nemo-speech-${NEMO_SPEECH_VERSION}-linux-x86_64-${BACKEND}.tar.gz"; \
    base="https://github.com/NVIDIA/NeMo-Speech.cpp/releases/download/v${NEMO_SPEECH_VERSION}"; \
    cd /tmp; \
    curl -fsSLO "$base/$name"; \
    curl -fsSLO "$base/$name.sha256"; \
    sha256sum -c "$name.sha256"; \
    mkdir -p /opt/nemo-speech; \
    tar -xzf "$name" -C /opt/nemo-speech --strip-components=1; \
    rm "$name" "$name.sha256"; \
    useradd --uid 1000 --create-home nemo

# /usr/lib/wsl/lib holds libd3d12 and libdxcore for Dozen, mounted from the WSL host at run time.
ENV PATH=/opt/nemo-speech/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/lib/wsl/lib \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics

USER nemo
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s \
  CMD curl -fsS http://127.0.0.1:8080/ready || exit 1

ENTRYPOINT ["nemo-speech"]
CMD ["serve", "--host", "0.0.0.0", "--port", "8080", \
     "--asr-model", "/models/nemotron-3.5-asr-streaming-0.6b.q8_0.gguf"]
