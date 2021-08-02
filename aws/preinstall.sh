#!/bin/bash

. "/etc/parallelcluster/cfnconfig"

case "${cfn_node_type}" in
    MasterServer)
	curl -o master_install.sh <remote URL>
	sh master_install.sh > /tmp/master_install.log
    ;;
    ComputeFleet)
	curl -o compute_install.sh 
	sh compute_install.sh > /tmp/compute_install.log
    ;;
    *)
    ;;
esac
