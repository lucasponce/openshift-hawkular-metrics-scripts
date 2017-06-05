LOGGING_HOSTNAME="logging.dev.hawkular.io"
LOGGING_VM_IP="192.168.122.232"
HOSTS_ENTRY="${LOGGING_VM_IP} ${LOGGING_HOSTNAME} openshift.${LOGGING_HOSTNAME} kibana.${LOGGING_HOSTNAME} mux.${LOGGING_HOSTNAME}"

sudo su -c "echo $HOSTS_ENTRY >> /etc/hosts"
ssh-copy-id root@${LOGGING_HOSTNAME}

ssh root@${LOGGING_HOSTNAME}

scp 03-install-from-vm.sh root@logging.dev.hawkular.io:/root
