LOGGING_VM_IP="192.168.122.207"
HAWKULAR_HOST="hawkular-metrics.app.${LOGGING_VM_IP}.nip.io"
HAWKULAR_TOKEN="$(oc whoami -t)"
HAWKULAR_PORT=443
HAWKULAR_TENANT="my_tenant"

curl -k -v \
       -H "Hawkular-Tenant: ${HAWKULAR_TENANT}" \
       -H "Authorization: Bearer ${HAWKULAR_TOKEN}" \
       -H "Content-Type: application/json" \
       -d @hackfest-definitions.json \
       https://${HAWKULAR_HOST}/hawkular/alerts/import/all | jq
