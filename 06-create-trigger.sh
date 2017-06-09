LOGGING_VM_IP="192.168.122.4"
HAWKULAR_HOST="hawkular-metrics.app.${LOGGING_VM_IP}.nip.io"
HAWKULAR_TOKEN="P1iz0oyudhxwdyO891pvK9BGgWyqigy4Nt3r-nemTjo"
HAWKULAR_PORT=443
HAWKULAR_TENANT="my_tenant"

curl -k -v \
       -H "Hawkular-Tenant: ${HAWKULAR_TENANT}" \
       -H "Authorization: Bearer ${HAWKULAR_TOKEN}" \
       -H "Content-Type: application/json" \
       -d @trigger-definitions.json \
       https://${HAWKULAR_HOST}/hawkular/alerts/import/all | jq
