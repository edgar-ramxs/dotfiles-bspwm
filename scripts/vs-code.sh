#!/usr/bin/env bash

# Salida en caso de error
set -e

# Definir directorio temporal para descargar archivos
TEMP_DIR=$(mktemp -d)
echo "Directorio temporal creado en: $TEMP_DIR"

# Descargar Discord
echo "Descargando Discord..."
DISCORD_URL="https://discord.com/api/download?platform=linux&format=deb"
DISCORD_DEB="$TEMP_DIR/discord.deb"
wget -O "$DISCORD_DEB" "$DISCORD_URL"

# Descargar Visual Studio Code
echo "Descargando Visual Studio Code..."
VSCODE_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
VSCODE_DEB="$TEMP_DIR/code.deb"
wget -O "$VSCODE_DEB" "$VSCODE_URL"

# Instalar paquetes
echo "Instalando Discord..."
sudo dpkg -i "$DISCORD_DEB"
sudo apt-get install -f -y  # Para resolver cualquier dependencia faltante

echo "Instalando Visual Studio Code..."
sudo dpkg -i "$VSCODE_DEB"
sudo apt-get install -f -y  # Para resolver cualquier dependencia faltante

# Limpiar archivos temporales
echo "Limpiando archivos temporales..."
rm -rf "$TEMP_DIR"

echo "Instalación completa."
