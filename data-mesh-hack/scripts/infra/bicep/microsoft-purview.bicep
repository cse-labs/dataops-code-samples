@description('The Azure region for the specified resources.')
param location string = resourceGroup().location

@description('The name of the Microsoft Purview account.')
param purviewAccountName string

resource purview 'Microsoft.Purview/accounts@2021-07-01' = {
  name: purviewAccountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    cloudConnectors: {}
    managedResourceGroupName: 'mrg-${purviewAccountName}'
    #disable-next-line BCP073
    friendlyName: purviewAccountName
    publicNetworkAccess: 'Enabled'
  }
}

output purviewAccountName string = purview.name
output purviewCatalogUri  string = purview.properties.endpoints.catalog
output purviewAssignedIdentity string = purview.identity.principalId
