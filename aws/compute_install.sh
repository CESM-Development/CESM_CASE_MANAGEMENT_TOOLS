#!/bin/bash

# Set up the 'python' alias to point to Python3 -- this is going away for newer CESM releases, I think, but may
# be needed for this 2.1.4-rcX version
ln -s /usr/bin/python3 /usr/bin/python

# Set up our search path
echo '/opt/ncar/software/lib' > /etc/ld.so.conf.d/ncar.conf

