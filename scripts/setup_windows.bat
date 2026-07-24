@echo off
setlocal

:: [EN] Check if the script is running as Administrator
:: [PT-BR] Verifica se o script esta sendo executado como Administrador
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo [EN] Error: Please run this script as Administrator. Right-click the .bat file and select "Run as administrator".
    echo [PT-BR] Erro: Por favor, execute este script como Administrador. Clique com o botao direito no arquivo .bat e selecione "Executar como administrador".
    echo.
    pause
    exit /b 1
)

set "URL=https://raw.githubusercontent.com/GMB8281/BlocklistForNoobPeople/refs/heads/master/blocklist/hosts"
set "HOSTS_DIR=%WINDIR%\System32\drivers\etc"
set "HOSTS_FILE=%HOSTS_DIR%\hosts"
set "TEMP_HOSTS=%TEMP%\new_hosts.txt"
set "TEMP_DL=%TEMP%\downloaded_hosts.txt"

echo [EN] Starting the process to update the hosts file...
echo [PT-BR] Iniciando o processo para atualizar o arquivo hosts...
echo ---------------------------------------------------------

:: [EN] Create a temporary file with default Windows entries
:: [PT-BR] Cria um arquivo temporario com as entradas padrao do Windows
echo [EN] Adding default system entries...
echo [PT-BR] Adicionando entradas padrao do sistema...
echo # Copyright (c) 1993-2009 Microsoft Corp. > "%TEMP_HOSTS%"
echo 127.0.0.1 localhost >> "%TEMP_HOSTS%"
echo ::1 localhost >> "%TEMP_HOSTS%"
echo. >> "%TEMP_HOSTS%"
echo # --- Blocklist Sites --- >> "%TEMP_HOSTS%"

:: [EN] Download the blocklist from GitHub using PowerShell
:: [PT-BR] Baixando a lista de bloqueio do GitHub usando PowerShell
echo [EN] Downloading the blocklist from GitHub...
echo [PT-BR] Baixando a lista de bloqueio do GitHub...
powershell -NoProfile -Command "(Invoke-WebRequest -Uri '%URL%' -UseBasicParsing).Content | Out-File -FilePath '%TEMP_DL%' -Encoding ascii"

:: [EN] Append the downloaded content to the new hosts file
:: [PT-BR] Adiciona o conteudo baixado ao novo arquivo hosts
type "%TEMP_DL%" >> "%TEMP_HOSTS%"

:: [EN] Backing up the original hosts file to hosts.bak
:: [PT-BR] Fazendo backup do arquivo hosts original para hosts.bak
echo [EN] Backing up the original hosts file to hosts.bak...
echo [PT-BR] Fazendo backup do arquivo hosts original para hosts.bak...
copy /Y "%HOSTS_FILE%" "%HOSTS_FILE%.bak" >nul

:: [EN] Replacing the system's hosts file
:: [PT-BR] Substituindo o arquivo hosts do sistema
echo [EN] Replacing the system's hosts file...
echo [PT-BR] Substituindo o arquivo hosts do sistema...
move /Y "%TEMP_HOSTS%" "%HOSTS_FILE%" >nul

:: [EN] Clean up the temporary download file
:: [PT-BR] Limpa o arquivo de download temporario
del /Q "%TEMP_DL%" >nul

:: [EN] Flush the DNS cache to apply changes immediately
:: [PT-BR] Limpa o cache de DNS para aplicar as mudancas imediatamente
echo [EN] Flushing DNS cache...
echo [PT-BR] Limpando o cache de DNS...
ipconfig /flushdns >nul

echo ---------------------------------------------------------
echo [EN] Done! The blocklist has been successfully applied.
echo [PT-BR] Concluido! A lista de bloqueio foi aplicada com sucesso.
echo.
pause