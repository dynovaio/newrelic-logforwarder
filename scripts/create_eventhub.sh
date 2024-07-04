# /bin/bash
# Configure function app to stream logs to Event Hub

# Usage:
# ./stream_function_logs_to_eventhub.sh

# Global variables
LOCATION="eastus"
RESOURCE_GROUP_NAME="rg-observability-demo"

# Create event hub namespace
EVENT_HUB_NAMESPACE_NAME="ehns-logforwarder-collector"

az eventhubs namespace create \
    --name "${EVENT_HUB_NAMESPACE_NAME}" \
    --resource-group "${RESOURCE_GROUP_NAME}" \
    --location "${LOCATION}"

# Create an event hub
EVENT_HUB_NAME="eh-logforwarder-collector"

az eventhubs eventhub create \
    --name "${EVENT_HUB_NAME}" \
    --namespace-name "${EVENT_HUB_NAMESPACE_NAME}" \
    --resource-group "${RESOURCE_GROUP_NAME}"

# Get event hub id
EVENT_HUB_ID=$(
    az eventhubs eventhub show \
        --name "${EVENT_HUB_NAME}" \
        --namespace-name "${EVENT_HUB_NAMESPACE_NAME}" \
        --resource-group "${RESOURCE_GROUP_NAME}" \
        --query "id" \
        --output tsv
)
