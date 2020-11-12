#!/bin/bash

name=$1
mdsSku=$2
ossSku=$3
instanceCount=$4
rsaPublicKey=$5
imageResourceGroup=$6
imageName=$7
existingVnetResourceGroup=$8
existingVnetName=$9
exsitingSubnetName=$10
mdtStorageSku=$11
mdtCacheOption=$12
mdtDiskSize=$13
mdtNumDisks=$14
ostStorageSku=$15
ostCacheOption=$16
ostDiskSize=$17
ostNumDisks=$18

az deployment group create -g $imageResourceGroup --template-file azuredeploy_embed.json --parameters \
    name="$name" \
    mdsSku="$mdsSku" \
    ossSku="$ossSku" \
    instanceCount="$instanceCount" \
    rsaPublicKey="$rsaPublicKey" \
    imageResourceGroup="$imageResourceGroup" \
    imageName="$imageName" \
    existingVnetResourceGroup="$existingVnetResourceGroup" \
    existingVnetName="$existingVnetName" \
    exsitingSubnetName="$exsitingSubnetName" \
    mdtStorageSku="$mdtStorageSku" \
    mdtCacheOption="$mdtCacheOption" \
    mdtDiskSize="$mdtDiskSize" \
    mdtNumDisks="$mdtNumDisks" \
    ostStorageSku="$ostStorageSku" \
    ostCacheOption="$ostCacheOption" \
    ostDiskSize="$ostDiskSize" \
    ostNumDisks="$ostNumDisks"

