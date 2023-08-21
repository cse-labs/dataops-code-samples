param AdminLogin string
@secure()
@minLength(8)
param AdminLoginPassword string
param serverName string
param cloudSalesDbName string
param cloudStreamingDbName string
//param SalesDacPacPath string = 'https://openhackartifacts.blob.${environment().suffixes.storage}/mdw/CloudSales.bacpac'
//param StreamingDacPacPath string = 'https://openhackartifacts.blob.${environment().suffixes.storage}/mdw/CloudStreaming.bacpac'
//@secure()
//param DacPacContainerSAS string
param location string = resourceGroup().location

resource sqlserver 'Microsoft.Sql/servers@2022-11-01-preview' = {
  name: serverName
  location: location
  tags: {
    displayName: serverName
  }
  properties: {
    administratorLogin: AdminLogin
    administratorLoginPassword: AdminLoginPassword
  }
}

resource sqlserver_AllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2022-11-01-preview' = {
  parent: sqlserver
  name: 'AllowAllWindowsAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

resource sqlserver_CloudSales 'Microsoft.Sql/servers/databases@2022-11-01-preview' = {
  parent: sqlserver
  name: cloudSalesDbName
  location: location
  tags: {
    displayName: cloudSalesDbName
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
  }
}

//resource sqlserver_CloudSales_Import 'Microsoft.Sql/servers/databases/extensions@2022-11-01-preview' = {
//  parent: sqlserver_CloudSales
//  name: 'Import'
//  properties: {
//    storageKeyType: 'SharedAccessKey'
//    storageKey: DacPacContainerSAS
//    storageUri: SalesDacPacPath
//    administratorLogin: AdminLogin
//    administratorLoginPassword: AdminLoginPassword
//    operationMode: 'Import'
//    authenticationType: 'SQL'
//  }
//  dependsOn: [
//    sqlserver_AllowAllWindowsAzureIps
//  ]
//}

resource sqlserver_CloudStreaming 'Microsoft.Sql/servers/databases@2022-11-01-preview' = {
  parent: sqlserver
  name: cloudStreamingDbName
  location: location
  tags: {
    displayName: cloudStreamingDbName
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
  }
}

//resource sqlserver_CloudStreaming_Import 'Microsoft.Sql/servers/databases/extensions@2022-11-01-preview' = {
//  parent: sqlserver_CloudStreaming
//  name: 'Import'
//  properties: {
//    storageKeyType: 'SharedAccessKey'
//    storageKey: DacPacContainerSAS
//    storageUri: StreamingDacPacPath
//    administratorLogin: AdminLogin
//    administratorLoginPassword: AdminLoginPassword
//    operationMode: 'Import'
//    authenticationType: 'SQL'
//  }
//  dependsOn: [
//    sqlserver_AllowAllWindowsAzureIps
//  ]
//}

output sqlserverName string = sqlserver.name
output sqlserverAdminLogin string = sqlserver.properties.administratorLogin
output sqlserverCloudSalesDbName string = sqlserver_CloudSales.name
output sqlserverCloudStreamingDbName string = sqlserver_CloudStreaming.name
