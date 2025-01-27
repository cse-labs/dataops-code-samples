param adminUsername string

@secure()
param adminPassword string
param sqlAuthenticationLogin string

@secure()
param sqlAuthenticationPassword string
param BackupStorageAccountName string
param BackupStorageContainerName string

@secure()
param BackupStorageContainerSAS string
param BackupFileName string
param DatabaseName string
param location string = resourceGroup().location
param namePrefix string = 'OHDataOnPremSQL'

var vnetId = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', SQLVirtualNetworkName)
var subnetRef = '${vnetId}/subnets/${subnetName}'
var location_var = location
var SQLVirtualMachineName = namePrefix
var SQLVirtualMachineSize = 'Standard_DS3_v2'
var SQLVirtualNetworkName = '${namePrefix}-VNet'
var SQLNetworkInterfaceName = '${namePrefix}-NIC'
var SQLNetworkSecurityGroupName = '${namePrefix}-NSG'
var addressPrefix = '10.0.0.0/24'
var subnetName = 'default'
var subnetPrefix = '10.0.0.0/24'
var SQLPublicIpAddressName = '${namePrefix}-PIP'
var publicIpAddressType = 'Dynamic'
var publicIpAddressSku = 'Basic'
var sqlConnectivityType = 'Local'
var sqlPortNumber = 1433
var sqlStorageDisksCount = 1
var sqlStorageWorkloadType = 'GENERAL'
var sqlStorageDisksConfigurationType = 'NEW'
var sqlStorageStartingDeviceId = 2
var rServicesEnabled = 'false'
var RestoreDBScriptFolder = 'CustomScripts'
var RestoreDBScriptFileName = 'RestoreDB.ps1'

resource SQLVirtualMachine 'Microsoft.Compute/virtualMachines@2018-06-01' = {
  name: SQLVirtualMachineName
  location: location_var
  properties: {
    osProfile: {
      computerName: SQLVirtualMachineName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: 'true'
      }
    }
    hardwareProfile: {
      vmSize: SQLVirtualMachineSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftSQLServer'
        offer: 'sql2019-ws2022'
        sku: 'Standard'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      dataDisks: [
        {
          createOption: 'empty'
          lun: 0
          diskSizeGB: '1023'
          caching: 'ReadOnly'
          managedDisk: {
            storageAccountType: 'Standard_LRS'
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: SQLNetworkInterface.id
        }
      ]
    }
  }
}

resource SQLVirtualMachineName_RestoreDB 'Microsoft.Compute/virtualMachines/extensions@2018-06-01' = {
  parent: SQLVirtualMachine
  name: 'RestoreDB'
  location: location_var
  tags: {
    displayName: 'RestoreDB'
  }
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.9'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://openhackpublic.blob.core.windows.net/modern-data-warehousing/DeploySQLVM.ps1'
        'https://openhackpublic.blob.core.windows.net/modern-data-warehousing/DisableIEESC.ps1'
        'https://openhackpublic.blob.core.windows.net/modern-data-warehousing/SqlVMExtensionDriver.ps1'
      ]
    }
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File ./SqlVMExtensionDriver.ps1 ${BackupStorageAccountName} ${BackupStorageContainerName} "${BackupStorageContainerSAS}" ${DatabaseName} ${BackupFileName} ${sqlAuthenticationLogin} "${sqlAuthenticationPassword}"'
    }
  }
  dependsOn: [

    Microsoft_SqlVirtualMachine_SqlVirtualMachines_SQLVirtualMachine
  ]
}

resource SQLVirtualMachineName_IaaSAntiMalware 'Microsoft.Compute/virtualMachines/extensions@2015-05-01-preview' = {
  parent: SQLVirtualMachine
  name: 'IaaSAntiMalware'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Security'
    type: 'IaaSAntimalware'
    typeHandlerVersion: '1.1'
    autoUpgradeMinorVersion: true
    settings: {
      AntimalwareEnabled: true
      Exclusions: {
        Paths: 'C:\\Users'
        Extensions: '.txt'
        Processes: 'taskmgr.exe'
      }
      RealtimeProtectionEnabled: 'true'
      ScheduledScanSettings: {
        isEnabled: 'true'
        scanType: 'Quick'
        day: '7'
        time: '120'
      }
    }
    protectedSettings: null
  }
}

resource Microsoft_SqlVirtualMachine_SqlVirtualMachines_SQLVirtualMachine 'Microsoft.SqlVirtualMachine/SqlVirtualMachines@2017-03-01-preview' = {
  name: SQLVirtualMachineName
  location: location_var
  properties: {
    virtualMachineResourceId: SQLVirtualMachine.id
    autoPatchingSettings: {
      enable: false
    }
    keyVaultCredentialSettings: {
      enable: false
      credentialName: ''
    }
    serverConfigurationsManagementSettings: {
      sqlConnectivityUpdateSettings: {
        connectivityType: sqlConnectivityType
        port: sqlPortNumber
        sqlAuthUpdateUserName: sqlAuthenticationLogin
        sqlAuthUpdatePassword: sqlAuthenticationPassword
      }
      sqlWorkloadTypeUpdateSettings: {
        sqlWorkloadType: sqlStorageWorkloadType
      }
      sqlStorageUpdateSettings: {
        diskCount: sqlStorageDisksCount
        diskConfigurationType: sqlStorageDisksConfigurationType
        startingDeviceId: sqlStorageStartingDeviceId
      }
      additionalFeaturesServerConfigurations: {
        isRServicesEnabled: rServicesEnabled
      }
    }
  }
}

resource SQLVirtualNetwork 'Microsoft.Network/virtualNetworks@2018-08-01' = {
  name: SQLVirtualNetworkName
  location: location_var
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
}

resource SQLNetworkInterface 'Microsoft.Network/networkInterfaces@2018-10-01' = {
  name: SQLNetworkInterfaceName
  location: location_var
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/publicIpAddresses', SQLPublicIpAddressName)
          }
        }
      }
    ]
    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', SQLNetworkSecurityGroupName)
    }
  }
  dependsOn: [
    SQLVirtualNetwork
    SQLPublicIpAddress
    SQLNetworkSecurityGroup
  ]
}

resource SQLPublicIpAddress 'Microsoft.Network/publicIpAddresses@2018-08-01' = {
  name: SQLPublicIpAddressName
  location: location_var
  properties: {
    publicIPAllocationMethod: publicIpAddressType
  }
  sku: {
    name: publicIpAddressSku
  }
}

resource SQLNetworkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2018-08-01' = {
  name: SQLNetworkSecurityGroupName
  location: location_var
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          priority: 300
          protocol: 'TCP'
          access: 'Allow'
          direction: 'Inbound'
          sourceApplicationSecurityGroups: []
          destinationApplicationSecurityGroups: []
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
    ]
  }
}
