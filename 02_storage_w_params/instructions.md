# Add parameters, variables and outputs to your Bicep config

## Open your Bicep config

1. Open the file ***main.bicep*** in VS Code.

## Add parameters

1. Add a parameter for the location of the storage account.  
   ***param location string = 'germanywestcentral'***
1. Add a parameter for a prefix.  
   ***param prefix string***

## Add decorators to your parameters

1. Add a description to the location parameter.  
   ***@description('The location of the storage account')***
1. Add valid values for the location parameter.  
   ***@allowed(['westeurope', 'northeurope', 'germanywestcentral'])***

1. Add a description to the prefix parameter.  
   ***@description('A special prefix which will be added to the storage account name.')***
1. Add parameter ***minLength*** and ***maxLength*** to the prefix parameter.  
   ***@minLength(3)***  
   ***@maxLength(6)***

## Add a variable

1. Add a variable for the storage account name with string interpolation.  
   ***var storageAccountName = '${prefix}mystorageq1w2e3'***

## Put things together

1. Change the resource specification referencing the location parameter.  
   ***location: location***
1. Change the resource specification referencing the variable for the storage account name.  
   ***name: storageAccountName***


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
  HINT: typical you need to specifiy the resource group with the --resource-group parameter:  
  ***az deployment group create --resource-group bicepDemo --template-file main.bicep --parameters prefix=[your_prefix]***
1. Log in to the [Azure Portal](https://portal.azure.com) and verify that the storage account with your specific prefix was created.  
ALTERNATIVELY:  
***az storage account list --query '[].{id:id, name:name, location:location, resourceGroup:resourceGroup}' --output table*** 

## Clean up your resources
1. Delete Storage Account  
  ***az resource delete --name "yourStorageAccountName" --resource-type "Microsoft.Storage/storageAccounts"***  

  ALTERNATIVELY: 
1. Delete the Resource Group  
  ***az group delete --name bicepDemo --yes***
##

### OPTIONAL 1: Create bicepparam file and use it for deployment
1. Open the main.bicep file and press CTRL+SHIFT+P for command palette
1. Type ***'Bicep: Generate Parameters file'*** and press Enter
1. Select ***bicepparam***
1. Select ***all***
1. Open the bicepparam file (default name is 'main.bicepparam') and fill in the values for the parameters. The file should look like this:  
```bicep
using './main.bicep'

param location = 'germanywestcentral'
param prefix = 'ankr'
```
6. Deploy your Bicep configuration ***az deployment group create --resource-group bicepDemo --template-file main.bicep --parameters main.bicepparam***

### OPTIONAL 2: Generate error by using invalid values  
1. Deploy your Bicep configuration with wrong location ***az deployment group create --resource-group bicepDemo --template-file main.bicep --parameters main.bicepparam --parameters location=westus***
1. HINT: see error in the output of the deployment command
1. Open the bicepparam file (default name is 'main.bicepparam') and change the value of prefix to a lower size than 3, e.g.
```bicep
using './main.bicep'

param location = 'germanywestcentral'
param prefix = 'ak'
```
4. HINT: see the error message as soon the value becoming invalid in the bicepparam file.
5. Save the file and deploy your Bicep configuration ***az deployment group create --resource-group bicepDemo --template-file main.bicep --parameters main.bicepparam***  
6. HINT: see the error message in the output of the deployment command
7. Revert the wrong value of step 3
7. Clean up your resources ***az group delete --name bicepDemo --yes***