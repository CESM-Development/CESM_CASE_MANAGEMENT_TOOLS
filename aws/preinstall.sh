#!/bin/bash

. "/etc/parallelcluster/cfnconfig"

case "${cfn_node_type}" in
    MasterServer)
	curl -o master_install.sh https://raw.githubusercontent.com/CESM-Development/CESM_CASE_MANAGEMENT_TOOLS/cesm2-waccm/aws/master_install.sh
	sh master_install.sh > /tmp/master_install.log
    ;;
    ComputeFleet)
	curl -o compute_install.sh https://raw.githubusercontent.com/CESM-Development/CESM_CASE_MANAGEMENT_TOOLS/cesm2-waccm/aws/compute_install.sh
	sh compute_install.sh > /tmp/compute_install.log
    ;;
    *)
    ;;
esac
