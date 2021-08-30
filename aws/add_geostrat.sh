#!/bin/bash

# Add the 'cesm' group
groupadd cesm

# add the 'geostrat' user (later, this functionality will be handled by the API)
# We'll check if the /home/geostrat directory exists and call with -M if it does:
if [ -d /home/geostrat ]; then
  adduser -c "NCAR GeoStrat" -d /home/geostrat -g cesm -M -s /bin/bash geostrat
else
  adduser -c "NCAR GeoStrat" -d /home/geostrat -g cesm -s /bin/bash geostrat
  runuser -l geostrat -c 'ln -s /scratch/geostrat ~/scratch'
  mkdir /scratch/geostrat
  mkdir /scratch/geostrat/inputdata
  chown -R geostrat:cesm /scratch/geostrat
  runuser -l geostrat -c 'mkdir ~/.ssh ; chmod 0700 ~/.ssh ; echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC77CEx4sOOknjyAATPtWPczk5bY3mrX0fN/aWNnhymkmMEXeAVEoJE6PCqz2A0s8lxnfW0G6MdsZrCqKnQwCuG9nMKcc+K/5sq0tTS1QVShd7aBBwz+dazWhIoUDRyPB6AMxyowl6FAaf1QhAUeUsaE+5eVVGxJOLK1DjwjioDUFGPgZige3MM1XwOzkyeJjQc49Hob88KQiMqbxysPB43gOgJ645qI+UXnshpnTmC3GfD9/HaGQ2+twTG09AH6N45CV1IvXXTsiSEOf7XFUKd51Tq/8jNy9byXIEJPZgUHqIMrrfFsWUSjrx5jh1k7lygHvGXa9g5dCiQpJscFG03Q8KexvvnLdfj3q+iTGJzwwfInRAoISZgZ4q2hvg0EjDB5Nnf4h4GuvNyYJxVdASxYp6j4QONVCCSsbYjlo3oDEqmlVjlkVcQPGuZYa1/R/sv40RxPVJ92dPqn7P14ggtJDGEXzBRRDuCmjX+ZXYAIuPkO9b8eaW1NI1Qz8cFKavOtnR62Pn+UDBWPrPaoVhmT+3scX8Kht90GU+diwG6K+t45nemfnGr4hCOClHbj+iNBBdkowOjZmqPcQwKSA5/azEXykxbHoLIpLSNuZyGVhaTseBNxTrgxXhUcnfNo20GN5kVaQ1IDvl2OLpGOp4KZftK+bzKahWpmXUlZKUhOw== pcluster@9c9863b70831" > ~/.ssh/authorized_keys'

fi
