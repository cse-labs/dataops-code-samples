param org1Name string
param org2Name string
@minLength(8)
@secure()
param SqlAdminLoginPassword string
param deployPurview bool = true
//param SalesDacPacPath string
//param StreamingDacPacPath string
//@secure()
//param BackupStorageContainerSAS string
param location string = resourceGroup().location

var org1NameLower = toLower(org1Name)
var org2NameLower = toLower(org2Name)
var uniqueDeploymentId = uniqueString(resourceGroup().id)

var sqlServerName = 'sqlserver-${org1NameLower}-${uniqueDeploymentId}'
var cloudSalesDbName = 'CloudSales'
var cloudStreamingDbName = 'CloudStreaming'
var SqlAdminLogin = toLower(org1Name)
var purviewAccountName = 'pview-${uniqueDeploymentId}'
var storageAccountName = 'st${uniqueDeploymentId}'
var keyVaultName = 'kv-${uniqueDeploymentId}'

var cosmosDBAccountName = 'cosmos-${org1NameLower}-${uniqueDeploymentId}'
var cosmosDatabaseName = org1NameLower
var cosmosOriginalContainerName = 'movies'
var cosmosNewContainerName = 'new-movies'
var storageContainerName = org2NameLower

module azureSqlDatabase './azure-sql.bicep' = {
  name: 'deployAzureSqlDatabase'
  params: {
    AdminLogin: SqlAdminLogin
    AdminLoginPassword: SqlAdminLoginPassword
    serverName: sqlServerName
    cloudSalesDbName: cloudSalesDbName
    cloudStreamingDbName: cloudStreamingDbName
//    SalesDacPacPath: SalesDacPacPath
//    StreamingDacPacPath: StreamingDacPacPath
//    DacPacContainerSAS: '?${BackupStorageContainerSAS}'
    location: location
  }
}

//module deploySqlVMLinkedTemplate '?' /*TODO: replace with correct path to https://openhackpublic.blob.core.windows.net/modern-data-warehousing/DeploySQLVM.json*/ = {
//  name: 'deploySqlVMLinkedTemplate'
//  params: {
//    adminUsername: VMAdminUsername
//    adminPassword: VMAdminPassword
//    sqlAuthenticationLogin: SqlAdminLogin
//    sqlAuthenticationPassword: SqlAdminLoginPassword
//    BackupStorageAccountName: RentalsBackupStorageAccountName
//    BackupStorageContainerName: RentalsBackupStorageContainerName
//    BackupStorageContainerSAS: BackupStorageContainerSAS
//    BackupFileName: RentalsBackupFileName
//    DatabaseName: RentalsDatabaseName
//    location: location
//    namePrefix: SQLFictitiousCompanyNamePrefix
//  }
//}

module cosmosDB './azure-cosmos-db.bicep' = {
  name: 'deployCosmosDB'
  params: {
    location: location
    accountName: cosmosDBAccountName
    databaseName: cosmosDatabaseName
    originalContainerName: cosmosOriginalContainerName
    newContainerName: cosmosNewContainerName
  }
}

module purviewAccount './microsoft-purview.bicep' =  if (deployPurview) {
  name: 'deployPurviewAccount'
  params: {
    purviewAccountName: purviewAccountName
    location: location
  }
}

module storageAccount './azure-storage-account.bicep' = {
  name: 'deployStorageAccount'
  params: {
    storageAccountName: storageAccountName
    containerName: storageContainerName
    location: location
  }
}

module keyVault './azure-keyvault.bicep' = {
  name: 'deployKeyVault'
  params: {
    keyVaultName: keyVaultName
    location: location
  }
}

output purviewAccountName string = deployPurview ? purviewAccount.outputs.purviewAccountName : ''
output purviewCatalogUri  string = deployPurview ? purviewAccount.outputs.purviewCatalogUri : ''
output purviewAssignedIdentity string = deployPurview ? purviewAccount.outputs.purviewAssignedIdentity : ''

output storageAccountName string = storageAccountName
output storageAccountResourceId string = storageAccount.outputs.storageAccountResourceId
output storageContainerName string = storageContainerName

output cosmosDBEndpoint string = cosmosDB.outputs.cosmosDBEndpoint
output cosmosDBAccountName string = cosmosDB.outputs.cosmosDBAccountName
output cosmosDBDatabaseName string = cosmosDB.outputs.cosmosDBDatabaseName
output cosmosDBOriginalContainerName string = cosmosDB.outputs.cosmosDBOriginalContainerName
output cosmosDBNewContainerName string = cosmosDB.outputs.cosmosDBNewContainerName

output sqlserverName string = azureSqlDatabase.outputs.sqlserverName
output sqlserverAdminLogin string = azureSqlDatabase.outputs.sqlserverAdminLogin
output sqlserverCloudSalesDbName string = azureSqlDatabase.outputs.sqlserverCloudSalesDbName
output sqlserverCloudStreamingDbName string = azureSqlDatabase.outputs.sqlserverCloudStreamingDbName

output keyVaultName string = keyVault.outputs.keyVaultName
