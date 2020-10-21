#!/bin/bash

./create_ci.sh azuredeploy_embed.json azuredeploy.json ciScript packer/lustre-setup-scripts setup_lustre.sh name storageAccount storageKey storageContainer logAnalyticsAccount logAnalyticsWorkspaceId logAnalyticsKey
