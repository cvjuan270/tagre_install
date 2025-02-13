#!/bin/bash

# Variables
DOMINIO="liz.tagre.pe"
PUERTO="17006"
CONFIG_PATH="/etc/nginx/conf.d/${DOMINIO}.conf"

# Crear archivo de configuración
echo "Creando configuración de Nginx para $DOMINIO..."

sudo bash -c "cat > $CONFIG_PATH" <<EOL
server {
    listen 80;
    server_name $DOMINIO;

    location / {
        proxy_pass http://127.0.0.1:$PUERTO;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOL

echo "Configuración creada en $CONFIG_PATH"

# Reiniciar Nginx para aplicar los cambios
sudo systemctl restart nginx
echo "Nginx reiniciado correctamente"
sudo certbot --nginx -d $DOMINIO
echo "Instalado SSL"
