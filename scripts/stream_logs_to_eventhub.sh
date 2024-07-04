# /bin/bash
# Configure function app to stream logs to Event Hub

# Usage:
# ./stream_function_logs_to_eventhub.sh function_app_name

# Parameters:
# - function_app_name: Function app name

# Read parameters
FUNCTION_APP_NAME=$1

# Check if the function_app_name is provided
if [ -z "$FUNCTION_APP_NAME" ]; then
    echo "function_app_name is required"
    exit 1
fi

# Global variables
LOCATION="eastus"
RESOURCE_GROUP_NAME="rg-observability-demo"
EVENT_HUB_NAMESPACE_NAME="ehns-logforwarder-collector"
EVENT_HUB_NAME="eh-logforwarder-collector"

# Get event hub id
EVENT_HUB_ID=$(
    az eventhubs eventhub show \
        --name "${EVENT_HUB_NAME}" \
        --namespace-name "${EVENT_HUB_NAMESPACE_NAME}" \
        --resource-group "${RESOURCE_GROUP_NAME}" \
        --query "id" \
        --output tsv
)

# Gt function resource id
FUNCTION_APP_ID=$(
    az functionapp show \
        --name "${FUNCTION_APP_NAME}" \
        --resource-group "${RESOURCE_GROUP_NAME}" \
        --query "id" \
        --output tsv
)

# Setup function app diagnostics settings
DIAGNOSTIC_SETTING_NAME="ds-greetings-javascript"

az monitor diagnostic-settings create \
    --name "${DIAGNOSTIC_SETTING_NAME}" \
    --resource "${FUNCTION_APP_ID}" \
    --resource-group "${RESOURCE_GROUP_NAME}" \
    --logs '[{"category": "FunctionAppLogs", "enabled": true}]' \
    --metrics '[{"category": "AllMetrics", "enabled": true}]' \
    --event-hub "${EVENT_HUB_ID}" \
    --event-hub-rule "RootManageSharedAccessKey"
