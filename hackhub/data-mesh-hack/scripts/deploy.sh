#!/bin/bash
helpFunction()
{
   echo ""
   echo "Usage: $0 [-n <integer>] [-p <string> [-f <boolean>]"
   echo -e "\t-n The number of teams hacking (1,2,...). Default is 1."
   echo -e "\t-p The SQL admin password. Default is a random password."
   echo -e "\t-f Flag to indicate weather to deploy Microsoft Purview (true/false). Default is false."
   echo -e "\t-r The deployment region. Default is 'australiaeast'."
   exit 1
}

default_team_count=1
default_sql_admin_password="$(mktemp -u "XXXXXXXXXXXX")#26"
default_deploy_purview=false
default_deployment_region="australiaeast"
resource_group_prefix="rg-team"
security_group_prefix="sg-team"
sg_purview_scanning="sg-pview-fabric-scan"
org1_name="southridge"
org2_name="fourthcoffee"
deployment_name_prefix="azuredeploy"
bicep_main_deployment_file="./infra/bicep/main.bicep"
bacpac_storage_container_sas="sp=rl&st=2021-03-11T23:29:56Z&se=2026-03-12T06:29:56Z&spr=https&sv=2020-02-10&sr=c&sig=D5jy97qh7LmF6GxHNcWAl5AcjcXK7BOxW5HxeQlU3BM%3D"
cloudsales_bacpac_uri="https://openhackartifacts.blob.core.windows.net/mdw/CloudSales.bacpac"
cloudstreaming_bacpac_uri="https://openhackartifacts.blob.core.windows.net/mdw/CloudStreaming.bacpac"
org1_original_movie_catalog_name="./data/${org1_name}/movies-${org1_name}-v1.json"
org1_new_movie_catalog_name="./data/${org1_name}/movies-${org1_name}-v2.json"
org2_files_location="./data/${org2_name}/"

#read -rp "How many teams are hacking? " team_count
#echo "Please provide the SQL admin password: " && read -rsp "" sql_admin_password
#read -rp "Do you want to deploy Microsoft Purview (true/false)? " deploy_purview

while getopts "n:p:f:r:" opt
do
   case "$opt" in
      n ) team_count="$OPTARG" ;;
      p ) sql_admin_password="$OPTARG" ;;
      f ) deploy_purview="$OPTARG" ;;
      r ) deployment_region="$OPTARG" ;;
      ? ) helpFunction ;;
   esac
done

if [ -z "${team_count}" ]; then
    team_count=${default_team_count}
fi

if [ -z "${sql_admin_password}" ]; then
    sql_admin_password="${default_sql_admin_password}"
fi

if [ -z "${deploy_purview}" ]; then
    deploy_purview=${default_deploy_purview}
fi

if [ -z "${deployment_region}" ]; then
    deployment_region=${default_deployment_region}
fi

for ((i = 1; i <= team_count; i++))
do
    team_name=$i
    if ((i < 10)); then
        team_name="0$i"
    fi
    team_security_group="${security_group_prefix}-${team_name}"

    if [ "${deploy_purview}" = true ]; then
        case $i in
            1) region="${deployment_region}" ;;
            2) region="japaneast" ;;
            3) region="centralindia" ;;
            4) region="northeurope" ;;
            5) region="westeurope" ;;
            6) region="eastus" ;;
            7) region="francecentral" ;;
            8) region="westus" ;;
            9) region="westus2" ;;
            *) region="${deployment_region}" ;;
        esac
    else
        region="${deployment_region}"
    fi

    random_suffix="$(echo $RANDOM | md5 | head -c 5)"
    resource_group_name="${resource_group_prefix}-${team_name}-${random_suffix}"
    deployment_name="${deployment_name_prefix}-$(date -u +'%m%d-%H%M%S')"
    echo "[I] Deploying to resource group '${resource_group_name}' in '${region}' with deployment name '${deployment_name}'"

    # Create the resource group if it does not exist
    az group create --name "${resource_group_name}" --location "${region}" --output none

    # Deploy the template to the resource group
    arm_output=$(az deployment group create \
        --name "${deployment_name}" \
        --resource-group "${resource_group_name}" \
        --template-file "${bicep_main_deployment_file}" \
        --parameters org1Name="${org1_name}" \
        --parameters org2Name="${org2_name}" \
        --parameters SqlAdminLoginPassword="${sql_admin_password}" \
        --parameters deployPurview="${deploy_purview}" \
        --output json)

    # Retrive account and key
    storage_account_resource_id=$(echo "${arm_output}" | jq -r '.properties.outputs.storageAccountResourceId.value')
    storage_account_name=$(echo "${arm_output}" | jq -r '.properties.outputs.storageAccountName.value')
    storage_container_name=$(echo "${arm_output}" | jq -r '.properties.outputs.storageContainerName.value')
    azure_storage_key=$(az storage account keys list \
        --account-name "${storage_account_name}" \
        --resource-group "${resource_group_name}" \
        --output json |
        jq -r '.[0].value')

    echo "[I] Uploading FourthCoffee files to storage account"
    az storage blob upload-batch \
        --destination "${storage_container_name}" \
        --account-name "${storage_account_name}" \
        --account-key "${azure_storage_key}" \
        --source "${org2_files_location}" \
        --overwrite \
        --output none

    # Retrive cosmosdb account and key
    cosmosdb_endpoint=$(echo "${arm_output}" | jq -r '.properties.outputs.cosmosDBEndpoint.value')
    cosomdb_account_name=$(echo "${arm_output}" | jq -r '.properties.outputs.cosmosDBAccountName.value')
    cosmosdb_database_name=$(echo "${arm_output}" | jq -r '.properties.outputs.cosmosDBDatabaseName.value')
    cosmosdb_original_container_name=$(echo "${arm_output}" | jq -r '.properties.outputs.cosmosDBOriginalContainerName.value')
    cosmosdb_new_container_name=$(echo "${arm_output}" | jq -r '.properties.outputs.cosmosDBNewContainerName.value')
    commosdb_account_key=$(az cosmosdb keys list \
        --name "${cosomdb_account_name}" \
        --resource-group "${resource_group_name}" \
        --output json |
        jq -r '.primaryMasterKey')

    echo "[I] Uploading Southridge original movie file to CosmosDB"
    python3 ./infra/populate-cosmosdb.py \
        "${cosmosdb_endpoint}" \
        "${commosdb_account_key}" \
        "${cosmosdb_database_name}" \
        "${cosmosdb_original_container_name}" \
        "${org1_original_movie_catalog_name}"

    echo "[I] Uploading Southridge new movie file to CosmosDB"
    python3 ./infra/populate-cosmosdb.py \
        "${cosmosdb_endpoint}" \
        "${commosdb_account_key}" \
        "${cosmosdb_database_name}" \
        "${cosmosdb_new_container_name}" \
        "${org1_new_movie_catalog_name}"

    # Import BACPAC files to Azure SQL DB
    sql_server_name=$(echo "${arm_output}" | jq -r '.properties.outputs.sqlserverName.value')
    sql_server_sales_db_name=$(echo "${arm_output}" | jq -r '.properties.outputs.sqlserverCloudSalesDbName.value')
    sql_server_streaming_db_name=$(echo "${arm_output}" | jq -r '.properties.outputs.sqlserverCloudStreamingDbName.value')
    sql_admin_username=$(echo "${arm_output}" | jq -r '.properties.outputs.sqlserverAdminLogin.value')

    echo "[I] Importing CloudSales.bacpac into Azure SQL DB (in background))"
    az sql db import -s "${sql_server_name}" \
        --name "${sql_server_sales_db_name}" \
        --resource-group "${resource_group_name}" \
        --admin-user "${sql_admin_username}" \
        --admin-password "${sql_admin_password}" \
        --storage-key-type "SharedAccessKey" \
        --storage-key "${bacpac_storage_container_sas}" \
        --storage-uri "${cloudsales_bacpac_uri}" \
        --no-wait \
        --output none

    echo "[I] Importing CloudStreaming.bacpac into Azure SQL DB (in background))"
    az sql db import -s "${sql_server_name}" \
        --name "${sql_server_streaming_db_name}" \
        --resource-group "${resource_group_name}" \
        --admin-user "${sql_admin_username}" \
        --admin-password "${sql_admin_password}" \
        --storage-key-type "SharedAccessKey" \
        --storage-key "${bacpac_storage_container_sas}" \
        --storage-uri "${cloudstreaming_bacpac_uri}" \
        --no-wait \
        --output none

    resource_group_id=$(az group show --name "${resource_group_name}" --output json| jq -r '.id')
    sg_group_id=$(az ad group show --group "${team_security_group}" --output json| jq -r '.id')
    kv_name=$(echo "${arm_output}" | jq -r '.properties.outputs.keyVaultName.value')

    # Generally, you already have a security group created for your team with dynamic membership rules. In that case, the existing security group will be used.
    # Is the security group is not found, then create it. Please note that the security group is with static user membership.
    # This is because the dynamic user membership is not supported in Azure CLI yet.
    # Later, you can either choose to add the members manually to this security group or modify the security group to use dynamic membership rules (preferred).
    if [ -z "${sg_group_id}" ]; then
        echo "[I] Creating Microsoft Entra security group '${team_security_group}'."
        sg_group_id=$(az ad group create --display-name "${team_security_group}" --mail-nickname "${team_security_group}" --output json| jq -r '.id')
        sleep 20
    fi
    echo "[I] Granting 'Storage Blob Data Contributor' role on the storage account to the corresponding SG (id: '${sg_group_id}')"
    az role assignment create \
        --role "Storage Blob Data Contributor" \
        --assignee-object-id "${sg_group_id}" \
        --assignee-principal-type "Group" \
        --scope "${storage_account_resource_id}" \
        --output none

    echo "[I] Granting 'Contributor' access on the resource group to the corresponding security group"
    az role assignment create \
        --role "Contributor" \
        --assignee-object-id "${sg_group_id}" \
        --assignee-principal-type "Group" \
        --scope "${resource_group_id}" \
        --output none

    if [ "${deploy_purview}" = true ]; then
        echo "[I] Adding the corresponding security group as root collection admin for Purview account"
        purview_account_name=$(echo "${arm_output}" | jq -r '.properties.outputs.purviewAccountName.value')
        az purview account add-root-collection-admin \
            --resource-group "${resource_group_name}" \
            --name "${purview_account_name}" \
            --object-id "${sg_group_id}" \
            --only-show-errors

        echo "[I] Adding the purview account to the security group 'sg-pview-fabric-scan' which allows Power BI scanning"
        purview_id=$(echo "${arm_output}" | jq -r '.properties.outputs.purviewAssignedIdentity.value')
        sg_purview_scanning_id=$(az ad group show --group "${sg_purview_scanning}" --output json| jq -r '.id')
        if [ -z "${sg_purview_scanning_id}" ]; then
            echo "[W] Security group '${sg_purview_scanning}' not found, creating a new one. Please do the following steps manually:"
            echo "    - Add this security group in Power BI admin portal to allow using read-only admin APIs."
            sg_purview_scanning_id=$(az ad group create --display-name "${sg_purview_scanning}" --mail-nickname "${sg_purview_scanning}" --output json| jq -r '.id')
            sleep 20
        fi
        az ad group member add \
            --group "${sg_purview_scanning_id}" \
            --member-id "${purview_id}"
    fi

    echo "[I] Granting all access permissions on Azure KeyVault secrets/keys to the deployment principal."
    kv_owner_object_id=$(az ad signed-in-user show --output json | jq -r '.id')
    az keyvault set-policy \
        --name "${kv_name}" \
        --resource-group "${resource_group_name}" \
        --secret-permissions all \
        --key-permissions all \
        --object-id "${kv_owner_object_id}" \
        --output none

    echo "[I] Granting get/list access permissions on Azure KeyVault secrets to the security group."
    az keyvault set-policy \
        --name "${kv_name}" \
        --resource-group "${resource_group_name}" \
        --secret-permissions get list \
        --object-id "${sg_group_id}" \
        --output none

    sleep 20

    echo "[I] Storing relevant keys/passwords to Azure KeyVault."
    echo "    [I] Storing secret 'cosmosDbAccountKey'"
    az keyvault secret set \
        --vault-name "${kv_name}" \
        --name "cosmosDbAccountKey" \
        --value "${commosdb_account_key}" \
        --output none
    echo "    [I] Storing secret 'storageAccountKey'"
    az keyvault secret set \
        --vault-name "${kv_name}" \
        --name "storageAccountKey" \
        --value "${azure_storage_key}" \
        --output none
    echo "    [I] Storing secret 'sqlAdminUsername'"
    az keyvault secret set \
        --vault-name "${kv_name}" \
        --name "sqlAdminUsername" \
        --value "${sql_admin_username}" \
        --output none
    echo "    [I] Storing secret 'sqlAdminPassword'"
    az keyvault secret set \
        --vault-name "${kv_name}" \
        --name "sqlAdminPassword" \
        --value "${sql_admin_password}" \
        --output none
done

echo "[I] Deployment completed! Please check the output for any errors."
