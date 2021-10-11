#!/bin/bash

#yum install -y lapack blas

yum -y install singularity

# Set up the 'python' alias to point to Python3 -- this is going away for newer CESM releases, I think, but may
# be needed for this 2.1.4-rcX version
ln -s /usr/bin/python3 /usr/bin/python

# Set up our search path
echo '/opt/ncar/software/lib' > /etc/ld.so.conf.d/ncar.conf

# Also add the compilers to the /etc/profile.d/oneapi.sh
echo 'source /opt/intel/oneapi/setvars.sh > /dev/null' > /etc/profile.d/oneapi.sh

#cd /tmp
#wget -q https://raw.githubusercontent.com/CESM-Development/CESM_CASE_MANAGEMENT_TOOLS/cesm2-waccm/aws/add_geostrat.sh
#sh add_geostrat.sh
