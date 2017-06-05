### on the VM
LOGGING_HOSTNAME="logging.dev.hawkular.es"
LOGGING_VM_IP="192.168.122.170"
HOSTS_ENTRY="${LOGGING_VM_IP} ${LOGGING_HOSTNAME} openshift.${LOGGING_HOSTNAME} kibana.${LOGGING_HOSTNAME} mux.${LOGGING_HOSTNAME} hawkular-metrics.${LOGGING_HOSTNAME}"

for port in 22 80 443 8443 24284
do 
  firewall-cmd --add-port=$port/tcp
  firewall-cmd --add-port=$port/tcp --permanent
done

curl https://raw.githubusercontent.com/ViaQ/Main/master/centos7-viaq.repo > /etc/yum.repos.d/centos7-viaq.repo

# we just want the dependencies, so, install (with dependencies) and remove it
yum install screen openshift-ansible git python2-passlib -y
yum remove openshift-ansible -y
mkdir -p /opt/ansible
cd /opt/ansible
git clone https://github.com/jpkrohling/openshift-ansible.git . -b JPK-HawkularAlertsWithLogging
curl https://raw.githubusercontent.com/ViaQ/Main/master/vars.yaml.template > vars.yaml
echo "${LOGGING_HOSTNAME}" > /etc/hostname
sudo su -c "echo $HOSTS_ENTRY >> /etc/hosts"

cat > /opt/ansible/ansible-inventory <<EOF
[OSEv3:children]
nodes
masters
[OSEv3:vars]
short_version=1.5
ansible_connection=local
openshift_release=v1.5
openshift_deployment_type=origin
openshift_master_identity_providers=[{'challenge': 'true', 'login': 'true', 'kind': 'AllowAllPasswordIdentityProvider', 'name': 'allow_all'}]
openshift_disable_check=disk_availability,memory_availability
openshift_hosted_logging_deploy=true
openshift_logging_install_logging=true
openshift_logging_image_prefix=docker.io/openshift/origin-
openshift_logging_image_version=latest
openshift_logging_namespace=logging
openshift_logging_es_cluster_size=1
openshift_hosted_metrics_deploy=true
openshift_metrics_install_metrics=true
openshift_metrics_image_prefix=jpkroehling/origin-
openshift_metrics_image_version=dev
openshift_metrics_hawkular_hostname=hawkular-metrics.app.${LOGGING_VM_IP}.nip.io
openshift_metrics_cassandra_replicas=1
[nodes]
localhost storage=True openshift_node_labels="{'region': 'infra'}" openshift_schedulable=True
[masters]
localhost storage=True openshift_node_labels="{'region': 'infra'}" openshift_schedulable=True
EOF

ANSIBLE_LOG_PATH=/tmp/ansible.log ansible-playbook -vvv -e @/opt/ansible/vars.yaml -i /opt/ansible/ansible-inventory /opt/ansible/playbooks/byo/config.yml
## sudo make me a sandwich
oc adm policy add-cluster-role-to-user cluster-admin developer
