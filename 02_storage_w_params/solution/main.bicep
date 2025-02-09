@description('The location of the storage account.')
@allowed(['westeurope', 'northeurope', 'germanywestcentral'])
param location string = 'germanywestcentral'

@description('A special prefix which will be added to the storage account name.')
@minLength(3)
@maxLength(6)
param prefix string
var storageAccountName = '${prefix}mystorageq1w2e3'


resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
