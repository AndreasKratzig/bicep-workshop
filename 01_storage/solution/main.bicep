resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'ankramystorageq1w2e3'
  location: 'germanywestcentral'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

}
