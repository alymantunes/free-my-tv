#!/bin/bash
# Gera o certificado Tizen (autor) e o perfil "freemytv" no volume tizen-data. Roda uma vez.
# A senha é digitada aqui, no terminal de quem roda: não vai para o chat nem para o histórico.
set -euo pipefail

read -r -s -p "Senha do certificado: " PASS; echo
read -r -s -p "Repita a senha: " PASS2; echo
[ "$PASS" = "$PASS2" ] || { echo "As senhas não conferem."; exit 1; }

DATA=/home/dev/tizen-studio-data
tizen certificate -a freemytv -n "Alym Antunes" -e "alym@camporacoes.com.br" -c BR -o "Campo Nutricao Animal" \
    -f freemytv -p "$PASS" -- "$DATA/keystore/author"

# Distribuidor padrão do Tizen (senha pública do próprio SDK).
tizen security-profiles add -n freemytv \
    -a "$DATA/keystore/author/freemytv.p12" -p "$PASS" \
    -d "/home/dev/tizen-studio/tools/certificate-generator/certificates/distributor/tizen-distributor-signer.p12" \
    -dp tizenpkcs12passfordsigner -f

tizen security-profiles list
