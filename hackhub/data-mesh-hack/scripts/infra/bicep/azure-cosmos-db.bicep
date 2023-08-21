param location string = resourceGroup().location
param accountName string
param databaseName string
param originalContainerName string
param newContainerName string

resource account 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: accountName
  location: location
  tags: {
  }
  kind: 'GlobalDocumentDB'
  properties: {
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    databaseAccountOfferType: 'Standard'
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
  parent: account
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource originalContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  parent: database
  name: originalContainerName
  properties: {
    resource: {
      id: originalContainerName
      partitionKey: {
        paths: [
          '/genre'
        ]
        kind: 'Hash'
      }
    }
  }
}

resource newContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  parent: database
  name: newContainerName
  properties: {
    resource: {
      id: newContainerName
      partitionKey: {
        paths: [
          '/genre'
        ]
        kind: 'Hash'
      }
    }
  }
}

output cosmosDBAccountName string = account.name
output cosmosDBEndpoint string = account.properties.documentEndpoint
output cosmosDBDatabaseName string = database.name
output cosmosDBOriginalContainerName string = originalContainer.name
output cosmosDBNewContainerName string = newContainer.name
//output cosmosDBKey string = listKeys(account.id, account.apiVersion).primaryMasterKey
