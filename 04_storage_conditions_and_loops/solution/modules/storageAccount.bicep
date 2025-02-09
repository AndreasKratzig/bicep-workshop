@description('The location of the storage account.')
param location string

@description('The name of the storage account.')
param storageAccountName string

@description('The Sku which will be used for the storage account.')
param skuName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
}

@description('The id of the Storage Account resource')
output id string = storageAccount.id

@description('The final name of the storage account')
output storageAccountName string = storageAccount.name

@description('The URL of the Storage Account Blob Endpoint')
output storageBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob
