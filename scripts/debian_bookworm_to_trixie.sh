#!/usr/bin/env bash

#  ██████╗ ███████╗██████╗ ██╗ █████╗ ███╗   ██╗    ████████╗██████╗ ██╗██╗  ██╗██╗███████╗
#  ██╔══██╗██╔════╝██╔══██╗██║██╔══██╗████╗  ██║    ╚══██╔══╝██╔══██╗██║╚██╗██╔╝██║██╔════╝
#  ██║  ██║█████╗  ██████╔╝██║███████║██╔██╗ ██║       ██║   ██████╔╝██║ ╚███╔╝ ██║█████╗  
#  ██║  ██║██╔══╝  ██╔══██╗██║██╔══██║██║╚██╗██║       ██║   ██╔══██╗██║ ██╔██╗ ██║██╔══╝  
#  ██████╔╝███████╗██████╔╝██║██║  ██║██║ ╚████║       ██║   ██║  ██║██║██╔╝ ██╗██║███████╗
#  ╚═════╝ ╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝       ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝╚══════╝

SOURCE_LIST="/etc/apt/sources.list"

if [ ! -f "${SOURCE_LIST}.bak" ]; then
    echo "Creando copia de seguridad de ${SOURCE_LIST}..."
    sudo cp $SOURCE_LIST ${SOURCE_LIST}.bak
    echo "Copia de seguridad creada en ${SOURCE_LIST}.bak"
else
    echo "La copia de seguridad ya existe."
fi

NEW_SOURCES="
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware

deb http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
"

echo "Actualizando $SOURCE_LIST con las nuevas fuentes para Debian Trixie..."
echo "$NEW_SOURCES" | sudo tee $SOURCE_LIST > /dev/null

if grep -q "trixie" $SOURCE_LIST; then
    echo "Actualización completada exitosamente."
else
    echo "Hubo un error al actualizar $SOURCE_LIST."
fi
