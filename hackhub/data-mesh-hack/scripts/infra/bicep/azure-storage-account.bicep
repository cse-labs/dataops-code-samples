@description('Name of the storage account.')
param storageAccountName string

@description('Name of the blob container')
param containerName string

@description('Azure region where resources should be deployed')
param location string

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  properties: {
    isHnsEnabled: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          enabled: true
        }
        blob: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  resource blobService 'blobServices' = {
    name: 'default'

    resource container 'containers' = {
      name: containerName
    }
  }
}

output storageAccountName string = storage.name
output storageContainerName string = containerName
output storageAccountResourceId string = storage.id
//output storageAccountKey string = listKeys(storage.id, storage.apiVersion).keys[0].value
