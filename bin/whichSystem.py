#!/usr/bin/python3

import re
import subprocess
import sys

def get_ttl(ip_address):
    try:
        # Ejecutar el ping y capturar la salida estándar
        result = subprocess.run(['ping', '-c', '1', ip_address], capture_output=True, text=True, timeout=5)
        output = result.stdout

        # Buscar el TTL en la salida del ping
        ttl_match = re.search(r"ttl=(\d+)", output, re.IGNORECASE)
        if ttl_match:
            ttl_value = int(ttl_match.group(1))
            return ttl_value
        else:
            return None  # TTL no encontrado

    except subprocess.TimeoutExpired:
        print(f"[!] Timeout al ejecutar ping a {ip_address}.")
        return None
    except Exception as e:
        print(f"[!] Error al ejecutar ping a {ip_address}: {e}")
        return None

def get_os(ttl):
    if ttl is None:
        return "Not Found"
    elif ttl >= 0 and ttl <= 64:
        return "Linux"
    elif ttl >= 65 and ttl <= 128:
        return "Windows"
    else:
        return "Not Found"

if __name__ == '__main__':
    # Validar argumentos de entrada
    if len(sys.argv) != 2:
        print("\n[!] Uso: python3 " + sys.argv[0] + " <direccion-ip>\n")
        sys.exit(1)

    ip_address = sys.argv[1]

    ttl = get_ttl(ip_address)

    os_name = get_os(ttl)
    if os_name != "Not Found":
        print(f"\n\t{ip_address} (ttl -> {ttl}): {os_name}")
    else:
        print(f"\n\t{ip_address} (ttl -> {ttl}): Sistema operativo no identificado.")
