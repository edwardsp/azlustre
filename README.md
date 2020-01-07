# azlustre

[![Deploy to Azure](https://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fedwardsp%2Fazlustre%2Fmaster%2Fazuredeploy.json)

This is a project to provision a Lustre cluster as quickly as possible.  All the Lustre setup scripting is taken from the [AzureHPC](https://github.com/Azure/azurehpc) but the difference in this project is the Lustre cluster is provisioned through an [ARM template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/) using a custom image.

This project includes the following:

* A [packer](https://www.packer.io/) script to build an image with the Lustre packages installed.
* An [ARM template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/) to deploy a Lustre cluster using the image.

## Getting Started

Check out the repository:

```
git clone https://github.com/edwardsp/azlustre
```

### Building the image

Packer is required for the build so download the latest version for your operating system from https://www.packer.io.  It is distributed as a single file so just put it somewhere that is in your `PATH`.  Go into the packer directory:

```
cd azlustre/packer
```

The following options are required to build:

| Variable            | Description                                         |
|---------------------|-----------------------------------------------------|
| var_subscription_id | Azure subscription ID                               |
| var_tenant_id       | Tenant ID for the service principal                 |
| var_client_id       | Client ID for the service principal                 |
| var_client_secret   | Client password for the service principal           |
| var_resource_group  | The resource group to put the image in (must exist) |
| var_image           | The image name to create                            |

These can be read by packer from a JSON file.  Use this template to create `options.json` and populate the fields:

```
{
    "var_subscription_id": "",
    "var_tenant_id": "",
    "var_client_id": "",
    "var_client_secret": "",
    "var_resource_group": "",
    "var_image": ""
}
```

Use the following command to build with packer:

```
packer build -var-file=options.json centos-7.7-lustre-2.12.3.json
```

Once this successfully completes the image will be available.

### Deploying the Lustre cluster

The "Deploy to Azure" button can be used once the image is available.  Alternatively, use this template to create `params.json` and populate the fields:

```
{
    "name": {
        "value": ""
    },
    "vmSku": {
        "value": "Standard_L16s_v2"
    },
    "instanceCount": {
        "value": 2
    },
    "rsaPublicKey": {
        "value": ""
    },
    "imageResourceGroup": {
        "value": ""
    },
    "imageName": {
        "value": ""
    },
    "existingVnetResourceGroupName": {
        "value": ""
    },
    "existingVnetName": {
        "value": ""
    },
    "existingSubnetName": {
        "value": ""
    },
    "storageAccount": {
        "value": ""
    },
    "storageContainer": {
        "value": ""
    },
    "storageKey": {
        "value": ""
    },
    "logAnalyticsAccount": {
        "value": ""
    },
    "logAnalyticsWorkspaceId": {
        "value": ""
    },
    "logAnalyticsKey": {
        "value": ""
    }
}
```

The can be deployed using the Azure CLI:

```
resource_group=<insert-resource-group-name>
location=<insert-location-to-use>

az group create --name $resource_group --location $location
az group deployment create --resource-group $resource_group --template-file azuredeploy.json --parameters @params.json
```