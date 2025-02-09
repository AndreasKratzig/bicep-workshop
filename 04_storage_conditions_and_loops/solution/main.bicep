@description('The location of the storage account.')
@allowed(['westeurope', 'northeurope', 'germanywestcentral'])
param location string = 'germanywestcentral'

@description('A special prefix which will be added to the storage account name.')
@minLength(3)
@maxLength(6)
param prefix string
var storageAccountName = '${prefix}storage'

param seedValue string = utcNow('T')
var uniqueDeploymentName = 'storageAccountName-${take(uniqueString(seedValue),4)}'

@allowed([
  'dev'
  'test'
  'prod'
])
param environment string = 'dev'
var storageAccountSkuName = (environment == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

@description('How many Storage accounts shall be deployed. The instance number will be used as a suffix for each storage account name')
param numberOfStorageAccounts int = 1

// Storage Account Loop
module storageAccount 'modules/storageAccount.bicep' = [
  for i in range(1, numberOfStorageAccounts): {
    name: '${uniqueDeploymentName}-no-${i}-of-${numberOfStorageAccounts}'
    params: {
      location: location
      storageAccountName: '${environment}${storageAccountName}${i}'
      skuName: storageAccountSkuName
    }
  }
]

@description('The URL of the Storage Account Blob Endpoint')
output storageBlobEndpoint array = [for saIndex in range(0, numberOfStorageAccounts): storageAccount[saIndex].outputs.storageBlobEndpoint]

@description('The Storage Account Information')
output storageInfo array = [
  for i in range(0, numberOfStorageAccounts): {
    storageBlobEndpoint: storageAccount[i].outputs.storageBlobEndpoint
    id: storageAccount[i].outputs.id
    name: storageAccount[i].outputs.storageAccountName
  }
]
