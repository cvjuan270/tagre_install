#!/bin/bash

OE_PATH="/opt/odoo/16/odoo/custom-addons/"
OE_VERSION="16.0"
mkdir $OE_PATH/OCA
cd $OE_PATH/OCA

git clone https://github.com/OCA/account-invoicing.git --depth=1 --branch $OE_VERSION
echo -e "\n ----------------Clone account-invoicing"
git clone https://github.com/OCA/reporting-engine.git --depth=1 --branch $OE_VERSION
echo -e "\n ----------------Clone account-engine"
git clone https://github.com/OCA/server-ux.git --depth=1 --branch $OE_VERSION
echo -e "\n ----------------Clone server-ux"
git clone https://github.com/OCA/account-financial-reporting.git --depth=1 --branch $OE_VERSION
echo -e "\n ----------------Clone account-financial-reporting"
git clone https://github.com/OCA/account-financial-tools.git --depth=1 --branch $OE_VERSION
echo -e "\n ----------------Clone account-financial-tools"

