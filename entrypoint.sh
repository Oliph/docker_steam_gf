#!/bin/bash

sed -i 's/KEY_TO_REPLACE/'"$STEAM_KEY"'/g' /app/steam_key.php
exec "$@"
