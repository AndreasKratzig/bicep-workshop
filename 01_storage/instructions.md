# Create and deploy your first Bicep config

## Open Visual Studio Code

1. Create a new directory for your Bicep content, e.g. ***storage***.
1. Open that directory in VS Code.

## Create a new Bicep file

1. Create a new file called ***main.bicep***

## Create a new Bicep resource

1. Start typing ***resource storageAccount '***  
  If the Bicep extension is properly installed, this should bring up suggestions for the resource type and the API version.
1. Select ***'Microsoft.Storage/storageAccounts@2023-05-01'***  
  This will insert the resource type and the API version.  
  **HINT**: Press CTRL + SPACE to bring up the suggestions, e.g. after @ symbol for different API versions.
1. Continue to type ***=***  
  This should make the Bicep extension to offer you to add ***'required-properties'***.
1. Fill in values for the required properties (choose a globally unique value for the ***name***-property). Note that the Bicep extension helps you finding valid values for the properties.

Your Bicep file should now look like this:

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'ankramystorageq1w2e3'
  location: 'germanywestcentral'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
```


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
  ***az deployment group create --template-file main.bicep***  
  HINT: typical you need to specifiy the resource group with the --resource-group parameter:  
  ***az deployment group create --resource-group bicepDemo --template-file main.bicep***
1. Log in to the [Azure Portal](https://portal.azure.com) and verify that the storage account was created.  
ALTERNATIVELY:  
***az deployment group list --output table*** 

## Clean up your resources
1. Delete Storage Account  
  ***az resource delete --name "yourStorageAccountName" --resource-type "Microsoft.Storage/storageAccounts"***  

  ALTERNATIVELY: 
1. Delete the Resource Group  
  ***az group delete --name bicepDemo --yes***

## 

### OPTIONAL: Use query switch to save the resource group name into a PowerShell variable for further use
3. Create a Resource Group  
```powershell
$rg = (az group create --name "rg-bicepDemo" --location "germanywestcentral" --query name -o tsv)
```
4. Deploy your Bicep configuration with Powershell variable 
```powershell
az deployment group create -g $rg -f main.bicep
```
5. Delete the Resource Group  
```powershell
az group delete -g $rg --yes
```