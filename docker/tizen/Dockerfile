# Tizen CLI (assina o .wgt) e Python (build + install via SDB) em container, sem instalar nada no host.
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl openjdk-17-jre-headless python3 zip unzip \
        libssl3 libcurl4 pciutils sudo net-tools \
    && rm -rf /var/lib/apt/lists/*

# O instalador do Tizen Studio se recusa a rodar como root.
RUN useradd -m -s /bin/bash dev
USER dev
WORKDIR /home/dev

ARG TIZEN_STUDIO=6.1
RUN curl -fsSL -o web-cli.bin \
        "https://download.tizen.org/sdk/Installer/tizen-studio_${TIZEN_STUDIO}/web-cli_Tizen_Studio_${TIZEN_STUDIO}_ubuntu-64.bin" \
    && chmod +x web-cli.bin \
    && ./web-cli.bin --accept-license /home/dev/tizen-studio \
    && rm web-cli.bin

# No Linux o CLI guarda a senha do certificado num chaveiro (D-Bus), que o container não tem: sem isso a
# senha some e `tizen package` falha com "Invaild password". Este substituto grava no volume tizen-data.
COPY --chown=dev:dev --chmod=755 secret-tool /home/dev/tizen-studio/tools/certificate-encryptor/secret-tool

# build.py procura ~/tizen-studio/tools/ide/bin/tizen
ENV PATH="/home/dev/tizen-studio/tools/ide/bin:/home/dev/tizen-studio/tools:${PATH}"
WORKDIR /work
