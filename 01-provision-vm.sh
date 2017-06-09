IMAGES_DIR=${HOME}/Downloads/images
LOGGING_HOSTNAME="logging.dev.hawkular.es"

cd "${IMAGES_DIR}"
echo "thepassword123" > /tmp/rootpw
virt-builder centos-7.3 -o logging.qcow2 --size 20G --format qcow2 --hostname logging --root-password file:/tmp/rootpw
sudo virt-install --import --os-variant=centos7.0 --memory 8096 --vcpus 4 --name logging --disk logging.qcow2 --noautoconsole

echo "Log into the machine via 'sudo virsh console logging', get the IP, add it to the /etc/hosts for the hostname ${LOGGING_HOSTNAME}"
echo "Use ip addr command in CentOS to get the IP (ifconfig not installed on minimal images :-) )"
echo "Update LOGGING_VM_IP variable in 02-config-vm.sh and 03-install-from-vm.sh"
echo "Be sure there is not an old entry on .ssh/known_hosts for ${LOGGING_HOSTNAME}"
echo "Remember, virsh console exists with CTRL + ]"


