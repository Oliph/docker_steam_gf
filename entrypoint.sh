#!/bin/bash

sed -i 's/KEY_TO_REPLACE/'"$STEAM_KEY"'/g' /var/www/steam_ffs/app/steam_key.php
exec "$@"
