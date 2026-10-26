#!/bin/bash
# Gera o certificado Tizen (autor) e o perfil "freemytv" no volume tizen-data. Roda uma vez.
# A senha é digitada aqui, no terminal de quem roda: não vai para o chat nem para o histórico.
# Se o certificado já existe, só refaz o perfil (a senha tem de ser a mesma): trocar de certificado
# faz as TVs recusarem a atualização de um app já instalado.
set -euo pipefail

read -r -s -p "Senha do certificado: " PASS; echo
[ "${#PASS}" -ge 8 ] || { echo "A senha veio vazia ou curta demais (mínimo 8 caracteres)."; exit 1; }

DATA=/home/dev/tizen-studio-data
P12="$DATA/keystore/author/freemytv.p12"

if [ -f "$P12" ]; then
    echo "Certificado já existe em $P12: só refaço o perfil."
else
    read -r -s -p "Repita a senha: " PASS2; echo
    [ "$PASS" = "$PASS2" ] || { echo "As senhas não conferem."; exit 1; }
    mkdir -p "$DATA/keystore/author"
    tizen certificate -a freemytv -n "Alym Antunes" -e "alym@camporacoes.com.br" -c BR -o "Campo Nutricao Animal" \
        -f freemytv -p "$PASS" -- "$DATA/keystore/author"
fi

# Distribuidor padrão do Tizen (senha pública do próprio SDK).
tizen security-profiles add -n freemytv -a "$P12" -p "$PASS" \
    -d "/home/dev/tizen-studio/tools/certificate-generator/certificates/distributor/tizen-distributor-signer.p12" \
    -dp tizenpkcs12passfordsigner -f

tizen security-profiles list
