## add the hawkular user to the fluentd role
espod=$(oc get pods -n logging -l component=es  -o name | awk -F\/ '{print $2}')
oc exec -n logging $espod -- curl -s -k \
    --cert /etc/elasticsearch/secret/admin-cert --key /etc/elasticsearch/secret/admin-key \
    https://localhost:9200/.searchguard.$espod/rolesmapping/0 | \
  python -c 'import json, sys; hsh = json.loads(sys.stdin.read())["_source"]; hsh["sg_role_fluentd"]["users"].append("'hawkular'"); print json.dumps(hsh)' | \
  oc exec -n logging -i $espod -- curl -s -k --cert /etc/elasticsearch/secret/admin-cert --key /etc/elasticsearch/secret/admin-key \
    https://localhost:9200/.searchguard.$espod/rolesmapping/0 -XPUT -d@- |     python -mjson.tool

## sudo make me a sandwich
oc adm policy add-cluster-role-to-user cluster-admin developer
