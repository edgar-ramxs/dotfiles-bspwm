#!/usr/bin/env bash

# Importar Navegador
source ~/.variables

# URL de búsqueda en Google
SEARCH_URL="https://www.google.com/search?q=clima"

"$BROWSER" "$SEARCH_URL" &
