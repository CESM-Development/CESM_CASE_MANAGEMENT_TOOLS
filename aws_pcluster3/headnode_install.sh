#!/bin/bash

curl -o master_install.sh https://raw.githubusercontent.com/CESM-Development/CESM_CASE_MANAGEMENT_TOOLS/cesm2-waccm/aws/master_install.sh
sh master_install.sh > /tmp/master_install.log

groupadd cesm
# add the 'geostrat' user (later, this functionality will be handled by the API)
# We'll check if the /home/geostrat directory exists and call with -M if it does:
if [ -d /home/geostrat ]; then
  adduser -c "NCAR GeoStrat" -d /home/geostrat -g cesm -M -s /bin/bash geostrat
fi

ln -s /usr/bin/python3 /usr/bin/python

# Set up our search path
echo '/opt/ncar/software/lib' > /etc/ld.so.conf.d/ncar.conf

# Also add the compilers to the /etc/profile.d/oneapi.sh
echo 'source /opt/intel/oneapi/setvars.sh > /dev/null' > /etc/profile.d/oneapi.sh
