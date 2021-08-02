#!/bin/bash

# Install the yum repo for all the oneAPI packages:
cat << EOF > /etc/yum.repos.d/oneAPI.repo
[oneAPI]
name=Intel(R) oneAPI repository
baseurl=https://yum.repos.intel.com/oneapi
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
EOF

# Install various tools we need for users (some of these are probably already on here, but I'm aiming for 
# consistency with the container setup, so duplicates will just be skipped)
yum -y install vim emacs-nox git subversion which sudo csh make m4 cmake wget file byacc curl-devel zlib-devel
yum -y install perl-XML-LibXML gcc-gfortran gcc-c++ dnf-plugins-core python3 perl-core ftp numactl-devel

# Install the blas and lapack libraries -- maybe we switch to MKL for these?  Need to test performance
dnf --enablerepo=powertools install -y blas-devel lapack-devel

# Set up the 'python' alias to point to Python3 -- this is going away for newer CESM releases, I think, but may
# be needed for this 2.1.4-rcX version
ln -s /usr/bin/python3 /usr/bin/python

# Install the 'limited' set of Intel tools we need - note that this also downloads
# and installs >25 other packages, but it's still only a 3GB install, vs the 20GB
# you get from the 'intel-hpckit' meta-package.
yum -y install intel-oneapi-compiler-fortran-2021.3.0 intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-2021.3.0 intel-oneapi-mpi-devel-2021.3.0 

# Now add all our libraries, into /opt/ncar/software/lib so they're accessible by compute nodes:
# (Note: This needs to be cleaned up for better updating of versions later!)
# We do this in /opt so that compute nodes don't need to have all this stuff installed, making
# boot time much faster.  The first line adds our location to the standard LD search path.
echo '/opt/ncar/software/lib' > /etc/ld.so.conf.d/ncar.conf

export LIBRARY_PATH=/opt/ncar/software/lib
export LD_LIBRARY_PATH=/opt/ncar/software/lib
export CPATH=/opt/ncar/software/include
export FPATH=/opt/ncar/software/include

source /opt/intel/oneapi/setvars.sh

mkdir /tmp/sources
cd /tmp/sources
wget -q https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz
tar zxf hdf5-1.12.0.tar.gz
cd hdf5-1.12.0
./configure --prefix=/opt/ncar/software
make -j 2 install
cd /tmp/sources
wget -q ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-c-4.7.4.tar.gz
tar zxf netcdf-c-4.7.4.tar.gz
cd netcdf-c-4.7.4
./configure --prefix=/opt/ncar/software
make -j 2 install
ldconfig
cd /tmp/sources
wget -q ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.5.3.tar.gz
tar zxf netcdf-fortran-4.5.3.tar.gz
cd netcdf-fortran-4.5.3
./configure --prefix=/opt/ncar/software
make -j 2 install
ldconfig
cd /tmp/sources
wget -q https://parallel-netcdf.github.io/Release/pnetcdf-1.12.1.tar.gz
tar zxf pnetcdf-1.12.1.tar.gz
cd pnetcdf-1.12.1
./configure --prefix=/opt/ncar/software CC=mpicc CXX=mpicxx FC=mpiifort
make -j 2 install
ldconfig
rm -rf /tmp/sources

