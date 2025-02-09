# Introduce conditional deployments and loops

## Open your Bicep config

1. Open the file ***main.bicep*** in VS Code.

## Conditional Deyploment - Add a parameter for the environment type to your Bicep config

1. Add a parameter called `environment` to your Bicep config. Allowed values should be `dev`, `test` and `prod` only. The default shall be `dev`.
1. Define a variable for the `storageAccountSkuName`. This is best to use variables rather than embedding the expressions directly into the resource properties.  
   Set the value of the variable to `Standard_GRS` if the `environment` is `prod` and to `Standard_LRS` otherwise.  
   Hint: Use the ternery operator `?` .
1. Add a new parameter to the storage account module. Use the name `skuName`.
1. Set the value of the `sku.name` property of the storage account resource config (storageAccount.bicep) to the value of the module parameter `skuName`. This way we have the option to specify the SKU name in the module call instead of hardcoding it.
1. Bicep Linter should now show you an error in the main.bicep file because you need to pass a value for the new module parameter `skuName`.  
Add the parameter `skuName` to the module call in the main file and use the the variable `storageAccountSkuName` which in turn is already set to `Standard_GRS` or `Standard_LRS` based on the `environment` parameter in step 2.

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
1. Deploy your Bicep configuration two times. One with default and one with 'prod' for the environment parameter.  
  ***az deployment group create --template-file main.bicep --parameters prefix=[your_prefix]***  
  ***az deployment group create --template-file main.bicep --parameters prefix=[your_prefix] environment=prod***
1. Log in to the [Azure Portal](https://portal.azure.com) and verify that the storage account was created with the correct SKU (LRS or GRS).

## Loops - Add a parameter for the number of storage accounts you want to deploy

1. Add a parameter called `numberOfStorageAccounts` to your Bicep config. The parameter should have a default value of 1.
1. Add a loop to your Bicep config that creates the number of storage accounts specified in the `numberOfStorageAccounts` parameter.  
   Hint: Use the `range` function to create the set of numbers.
1. Pass the loop index for having a unique name for the storage account as well as for the deployment name.
1. Change the output of the main.bicep file into an array of names of the storage accounts, e.g. `output storageBlobEndpoint array = [for saIndex in range(0, numberOfStorageAccounts): storageAccount[saIndex].outputs.storageBlobEndpoint]`
1. Deploy your Bicep configuration to Azure.  
   ***az deployment group create --resource-group bicepDemo --template-file main.bicep --parameters prefix=[your_prefix] numberOfStorageAccounts=2***
1. Log in to the [Azure Portal](https://portal.azure.com) and verify that the storage accounts were created correctly. Look into the main deployment step and check the outputs.  
ALTERNATIVELY:  
***az deployment group show --name main --query properties.outputs***
   
## Clean up your resources

1. Delete the Resource Group  
   ***az group delete --name bicepDemo --yes***

##

### OPTIONAL 1:

1. Check the deployment in the Azure Portal and verify that the correct number of storage accounts was created.
1. Deploy again your Bicep configuration with an additional storage account and create a JSON object from the output.  
   ***az deployment group create --resource-group bicepDemo --template-file main.bicep --parameters prefix=[your_prefix] numberOfStorageAccounts=3 --query properties.outputs***