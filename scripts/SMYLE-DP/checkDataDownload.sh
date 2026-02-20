#!/bin/bash


# Years, mbrs, variables
years=$(seq 2010 2010)
mbrs=$(seq -w 01 10)   # pads with zero: 01–10
vars="rest rof lnd"



for Y in $years; do
  case=v21.LR.BSMYLEsmbb.${Y}-11.001
  for VAR in $vars; do
    echo $M
  for M in $mbrs; do
      echo $VAR

      ls -lR "$SCRATCH/archive/$case/archive.0$M/$VAR" | wc

    done
  done
done

