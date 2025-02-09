@description('The location of the storage account.')
param location string

@description('The name of the storage account.')
param storageAccountName string


resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

@description('The URL of the Storage Account Blob Endpoint')
output storageBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob
