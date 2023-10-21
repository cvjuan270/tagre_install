#!/bin/bash

OE_PATH="/opt/odooSaas/custom-addons/"
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
git clone https://github.com/OCA/server-tools.git --depth=1 --branch $OE_VERSION
echo -e "\n ----------------Clone server-tools"

git clone https://github.com/OCA/account-analytic.git --depth=1 --branch $OE_VERSION
echo -e "\n ----------------Clone account-analytic"
git clone https://github.com/OCA/server-backend.git --depth=1 --branch $OE_VERSION
echo -e "\n ----------------Clone server-backend"
git clone https://github.com/OCA/web.git --depth=1 --branch $OE_VERSION
echo -e "\n ----------------Clone web"

git clone https://github.com/OCA/stock-logistics-warehouse.git --depth=1 --branch $OE_VERSION
git clone https://github.com/OCA/stock-logistics-workflow.git --depth=1 --branch $OE_VERSION
git clone https://github.com/OCA/stock-logistics-reporting.git --depth=1 --branch $OE_VERSION
git clone https://github.com/OCA/wms.git --depth=1 --branch $OE_VERSION
