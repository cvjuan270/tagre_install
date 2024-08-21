#!/bin/bash

OE_USER="roma_hoteles"
# Example "Juan Collado, 993433774, "
OE_GECOS = "ODOO"
OE_HOME="/opt/$OE_USER"
OE_HOME_EXT="/$OE_USER/${OE_USER}-server"
INSTALL_WKHTMLTOPDF="False"
OE_PORT="8100"
OE_VERSION="17.0"
INSTALL_NGINX="False"
OE_SUPERADMIN="admin"
# Set to "True" to generate a random password, "False" to use the variable in OE_SUPERADMIN
GENERATE_RANDOM_PASSWORD="True"
OE_CONFIG="${OE_USER}-server"

# -------------------------------------------
# Update server
# -------------------------------------------
echo -e "\n------Update server"
sudo apt update
# -------------------------------------------
# Install postgresQL
# -------------------------------------------
echo -e "\n---- Install postgresQL"
# sudo apt install postgresql -y
echo -e "\n---- Create the ODOO PostgresQl User"
sudo su - postgres -c "createuser -s $OE_USER" 2 >/dev/null || true
# ----------------------------------------------------------------
# Install dependencies
# ----------------------------------------------------------------
echo -e "\n---- Install dependencies"
sudo apt install python3-pip wget python3-dev python3-venv python3-wheel libxml2-dev libpq-dev libjpeg8-dev liblcms2-dev libxslt1-dev zlib1g-dev libsasl2-dev libldap2-dev build-essential git libssl-dev libffi-dev libmysqlclient-dev libjpeg-dev libblas-dev libatlas-base-dev -y
echo -e "\n---- Crate ODOO system user"
sudo adduser --system --quiet --shell=/bin/bash --home=$OE_HOME --gecos 'ODOO' --group $OE_USER
sudo adduser $OE_USER sudo
#sudo su $OE_USER
cd $OE_HOME
echo -e "\n----Dowload odoo"
sudo git clone https://www.github.com/odoo/odoo --depth 1 --branch $OE_VERSION
echo -e "\n----Crear entorno virtual"
python3 -m venv venv
source venv/bin/activate
echo -e "n Install requirements"
pip3 install wheel
pip3 install -r odoo/requirements.txt
deactivate
echo "\n Create custom module directory"
sudo su $OE_USER -c "mkdir $OE_HOME/custom-addons"
echo -e "\n---- Setting permissions on home folder ----"

sudo chown -R $OE_USER:$OE_USER $OE_HOME/*

echo -e "* Create server config file"
sudo touch /etc/${OE_CONFIG}.conf
sudo su root -c "printf '[options] \n; This is the password that allows database operations:\n' >> /etc/${OE_CONFIG}.conf"
if [ $GENERATE_RANDOM_PASSWORD = "True" ]; then
    echo -e "* Generating random admin password"
    OE_SUPERADMIN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
fi
sudo su root -c "printf 'admin_passwd = ${OE_SUPERADMIN}\n' >> /etc/${OE_CONFIG}.conf"
sudo su root -c "printf 'http_port = ${OE_PORT}\n' >> /etc/${OE_CONFIG}.conf"
sudo su root -c "printf 'logfile = /var/log/${OE_CONFIG}.log\n' >> /etc/${OE_CONFIG}.conf"
sudo su root -c "printf 'addons_path=${OE_HOME}/odoo/addons,${OE_HOME}/custom-addons\n' >> /etc/${OE_CONFIG}.conf"
sudo chown $OE_USER:$OE_USER /etc/${OE_CONFIG}.conf
sudo chmod 640 /etc/${OE_CONFIG}.conf

echo -e "\n----- Create service"
sudo su root -c "printf '[Unit]\n' >> /etc/systemd/system/${OE_USER}.service"
sudo su root -c "printf 'Description=Odoo-${OE_USER}\n' >> /etc/systemd/system/${OE_USER}.service"
sudo su root -c "printf 'After=network.target\n' >> /etc/systemd/system/${OE_USER}.service"
sudo su root -c "printf '[Service]\n' >> /etc/systemd/system/${OE_USER}.service"
sudo su root -c "printf 'Type=simple\n' >> /etc/systemd/system/${OE_USER}.service"
sudo su root -c "printf 'User=${OE_USER}\n' >> /etc/systemd/system/${OE_USER}.service"
sudo su root -c "printf 'Group=${OE_USER}\n' >> /etc/systemd/system/${OE_USER}.service"
sudo su root -c "printf 'ExecStart=${OE_HOME}/venv/bin/python3 ${OE_HOME}/odoo/odoo-bin -c /etc/${OE_USER}-server.conf\n' >> /etc/systemd/system/${OE_USER}.service"
sudo su root -c "printf 'SKillMode=mixed\n' >> /etc/systemd/system/${OE_USER}.service"
sudo su root -c "printf '[Install]\n' >> /etc/systemd/system/${OE_USER}.service"
sudo su root -c "printf 'WantedBy=multi-user.target\n' >> /etc/systemd/system/${OE_USER}.service"
sudo systemctl daemon-reload
sudo systemctl enable --now ${OE_USER}.service
echo -e "\n----- odoo install\n Admin password: ${OE_SUPERADMIN}"






