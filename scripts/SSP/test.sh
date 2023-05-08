#!/bin/bash -l

# Loop over members
#for n in \
#0111 0121 0131 0141 0161 0171 0181 0191 \
#0211 0221 0231 0241 0261 0271 0281 0291
#do
for n in \
0111 0121 0131 0181 0191 0231 0241 0271 0281
do

  echo === Starting member ${n} ===

  if [[ ${n} == 0111 || ${n} == 0121 || ${n} == 0131 || ${n} == 0181 || ${n} == 0191 || \
        ${n} == 0231 || ${n} == 0241 || ${n} == 0271 || ${n} == 0281 ]] 
  then
      echo "first stop" ${n}
  else
      echo "second stop"
  fi

  echo ============================

done

