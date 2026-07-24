#!/bin/bash

# [EN] Check if the script is running as root (administrator)
# [PT-BR] Verifica se o script está sendo executado como root (administrador)
if [ "$EUID" -ne 0 ]; then
  echo "[EN] Error: Please run this script as root (use sudo)."
  echo "[PT-BR] Erro: Por favor, execute este script como root (use sudo)."
  exit 1
fi

URL="https://raw.githubusercontent.com/GMB8281/BlocklistForNoobPeople/refs/heads/master/blocklist/hosts"

echo "[EN] Starting the process to update /etc/hosts..."
echo "[PT-BR] Iniciando o processo para atualizar o /etc/hosts..."
echo "---------------------------------------------------------"

# [EN] Create a temporary file
# [PT-BR] Cria um arquivo temporário
TEMP_HOSTS=$(mktemp)

# [EN] Adding default localhost entries so the system doesn't break
# [PT-BR] Adicionando entradas padrão do localhost para que o sistema não quebre
echo "[EN] Adding default system entries..."
echo "[PT-BR] Adicionando entradas padrão do sistema..."
cat <<EOF > "$TEMP_HOSTS"
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# --- Blocklist Sites ---
EOF

echo "[EN] Downloading the blocklist from GitHub..."
echo "[PT-BR] Baixando a lista de bloqueio do GitHub..."

# [EN] Download the content using curl or wget and append it to the temp file
# [PT-BR] Baixa o conteúdo usando curl ou wget e adiciona ao arquivo temporário
if command -v curl &> /dev/null; then
    curl -s "$URL" >> "$TEMP_HOSTS"
elif command -v wget &> /dev/null; then
    wget -qO- "$URL" >> "$TEMP_HOSTS"
else
    echo "[EN] Error: Neither 'curl' nor 'wget' was found. Please install one of them."
    echo "[PT-BR] Erro: Nem o 'curl' nem o 'wget' foram encontrados. Por favor, instale um deles."
    rm -f "$TEMP_HOSTS"
    exit 1
fi

echo "[EN] Backing up the original /etc/hosts file to /etc/hosts.bak..."
echo "[PT-BR] Fazendo backup do arquivo /etc/hosts original para /etc/hosts.bak..."
cp /etc/hosts /etc/hosts.bak

echo "[EN] Replacing the system's hosts file..."
echo "[PT-BR] Substituindo o arquivo hosts do sistema..."
mv "$TEMP_HOSTS" /etc/hosts
chmod 644 /etc/hosts

echo "---------------------------------------------------------"
echo "[EN] Done! The blocklist has been successfully applied."
echo "[PT-BR] Concluído! A lista de bloqueio foi aplicada com sucesso."
