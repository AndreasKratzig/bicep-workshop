# Refactor your template to use modules

## Open your Bicep config

1. Open the file ***main.bicep*** in VS Code.

## Refactor the config so that the resources are in modules

1. Create a new folder called ***modules***.
1. Save the ***main.bicep*** file as ***storageAccount.bicep*** in the ***modules*** folder.

The storage module should fulfill the following requirements:
- The storage module should have a parameter called ***location*** with description but no defaults or deacorators.
- The storage module should have a parameter called ***storageAccountName***  with description but no defaults or decorators.
- The storage module should have no other parameters.
- The storage module should return the ***properties.primaryEndpoints.blob*** property of the storage account resource with description, e.g. `storageBlobEndpoint` and `@description('The URL of the Storage Account Blob Endpoint')`.

The main bicep should fulfill the following requirements:
- The main bicep calls the storage module with the mandatory parameters:  
`module storageAccount 'modules/storageAccount.bicep' = {`
- The main bicep should return the ***storageBlobEndpoint*** referencing the output of the storage account module:  
`output storageBlobEndpoint string = storageAccount.outputs.storageBlobEndpoint`


## Deploy your Bicep configuration to Azure

1. Log in to Azure  
  ***az login***  
  or   
  ***az login --tenant [your_tenant_id]***  
  when you have multiple tenants.
1. Select your Subscription  
  ***az account set --subscription [your_subscription]***  
  To see all your subscriptions, use:  
  ***az account list --output table***
1. Create a Resource Group  
  ***az group create --name bicepDemo --location germanywestcentral***  
   HINT: If you already have a resource group, you can skip this step.  
1. Configure az cli to use the resource group as default.  
   ***az configure --defaults group=YourResourceGroup***  
   To unset the default resource group, use:  
    ***az configure --defaults group=''***
1. Deploy your Bicep configuration  
  ***az deployment group create --template-file main.bicep --parameters prefix=[your_prefix]***
1. Log in to the [Azure Portal](https://portal.azure.com) and verify that the storage account was created.
1. Check in the Azure Portal the deplyoment page of the resource group the deployment names and the name of module.  
ALTERNATIVELY:  
  ***az deployment group list --resource-group bicepDemo --output table***

## Clean up your resources
1. Delete Storage Account  
  ***az resource delete --name "yourStorageAccountName" --resource-type "Microsoft.Storage/storageAccounts"***  

  ALTERNATIVELY: 
1. Delete the Resource Group  
  ***az group delete --name bicepDemo --yes***
##

### OPTIONAL 1: Use time stamp as value for unique deployment name
1. Add parameter ***seedValue*** to the main.bicep file
2. Add the following code to the main.bicep file and to generate each time a unique deployment name due to the time stamp
```bicep
param seedValue string = utcNow('T')
var uniqueDeploymentName = 'storageAccountName-${take(uniqueString(seedValue),4)}'
```
3. Use parameter ***uniqueDeploymentName*** for the name property of the module in the main.bicep file, e.g.:
```bicep	
module storageAccount 'modules/storageAccount.bicep' = {
  name: uniqueDeploymentName
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}
```
4. Check in the Azure Portal the deplyoment page of the resource group the deployment names and the name of module.
ALTERNATIVELY:  
  ***az deployment group list --resource-group bicepDemo --output table***

