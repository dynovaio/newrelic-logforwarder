# /bin/bash
# Configure function app to stream logs to Event Hub

# Usage:
# ./stream_function_logs_to_eventhub.sh NEW_RELIC_LICENSE_KEY

# Parameters:
# - NEW_RELIC_LICENSE_KEY: New Relic license key

# Read parameters
NEW_RELIC_LICENSE_KEY=$1

if [ -z "$NEW_RELIC_LICENSE_KEY" ]; then
    echo "NEW_RELIC_LICENSE_KEY is required"
    exit 1
fi

# Global variables
LOCATION="eastus"
RESOURCE_GROUP_NAME="rg-observability-demo"

# Get Eventhub Connection string
EVENT_HUB_NAMESPACE_NAME="ehns-logforwarder-collector"
EVENT_HUB_NAME="eh-logforwarder-collector"

EVENT_HUB_CONNECTION_STRING=$(
    az eventhubs namespace authorization-rule keys list \
        --name RootManageSharedAccessKey \
        --namespace-name "${EVENT_HUB_NAMESPACE_NAME}" \
        --resource-group "${RESOURCE_GROUP_NAME}" \
        --query primaryConnectionString \
        --output tsv
)

# Create settings for New Relic
FUNCTION_APP_NAME="fn-logforwarder-afn"

az functionapp config appsettings set \
    --name "${FUNCTION_APP_NAME}" \
    --resource-group "${RESOURCE_GROUP_NAME}" \
    --settings "NR_LICENSE_KEY=${NEW_RELIC_LICENSE_KEY}"

az functionapp config appsettings set \
    --name "${FUNCTION_APP_NAME}" \
    --resource-group "${RESOURCE_GROUP_NAME}" \
    --settings "eventHubName=${EVENT_HUB_CONNECTION_STRING}"

az functionapp config appsettings set \
    --name "${FUNCTION_APP_NAME}" \
    --resource-group "${RESOURCE_GROUP_NAME}" \
    --settings "NR_TRIGGER_PATH=${EVENT_HUB_NAME}"

az functionapp config appsettings set \
    --name "${FUNCTION_APP_NAME}" \
    --resource-group "${RESOURCE_GROUP_NAME}" \
    --settings "NR_ENVIRONMENT=qa"

az functionapp config appsettings set \
    --name "${FUNCTION_APP_NAME}" \
    --resource-group "${RESOURCE_GROUP_NAME}" \
    --settings "NR_CUSTOM_PROPERTIES_PREFIX=sb"

az functionapp config appsettings set \
    --name "${FUNCTION_APP_NAME}" \
    --resource-group "${RESOURCE_GROUP_NAME}" \
    --settings "NR_ENVIRONMENT=qa"
