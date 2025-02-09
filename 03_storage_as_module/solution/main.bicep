@description('The location of the storage account.')
@allowed(['westeurope', 'northeurope', 'germanywestcentral'])
param location string = 'germanywestcentral'

@description('A special prefix which will be added to the storage account name.')
@minLength(3)
@maxLength(6)
param prefix string
var storageAccountName = '${prefix}mystorageq1w2e3'

param seedValue string = utcNow('T')
var uniqueDeploymentName = 'storageAccountName-${take(uniqueString(seedValue),4)}'

module storageAccount 'modules/storageAccount.bicep' = {
  name: uniqueDeploymentName
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

@description('The URL of the Storage Account Blob Endpoint')
output storageBlobEndpoint string = storageAccount.outputs.storageBlobEndpoint
