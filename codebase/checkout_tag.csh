#!/bin/csh -f
### set the path where you want your CESMROOT to reside
set PATH    = /glade/work/$USER/cesm_tags-test
set TAG     = cesm2.1.4-rc.08

# Create the path if it doesn't exist
if (! -d $PATH) then
   mkdir $PATH
endif

cd $PATH

git clone -b $TAG https://github.com/ESCOMP/CESM.git $TAG
cd $TAG
./manage_externals/checkout_externals

