#!/usr/bin/env bash
#
# sar -u | ./minmax.sh
#
set -euo pipefail

function compare()
{
  i=${1:=0}
  j=${2:=0}
  max=$j

  if [[ "$i" =~ ^-?[0-9]*[.,]?[0-9]*$ ]]
  then
    CMP=$(echo $i ">" $j|bc -l)
    if [ $CMP -gt 0 ]
    then
      max=$i
    fi
  fi
  echo $max
}

MAX_U=0
MAX_N=0
MAX_S=0
MAX_IO=0
MAX_ST=0
MAX_I=0

while read CMD
do
  if [[ "$CMD" =~ [A|P]M ]]
  then
    USER=$(echo $CMD   | awk '{print $4}')
    NICE=$(echo $CMD   | awk '{print $5}')
    SYSTEM=$(echo $CMD | awk '{print $6}')
    IOWAIT=$(echo $CMD | awk '{print $7}')
    STEAL=$(echo $CMD  | awk '{print $8}')
    IDLE=$(echo $CMD   | awk '{print $9}')

    MAX_U=$(compare  $USER   $MAX_U)
    MAX_N=$(compare  $NICE   $MAX_N)
    MAX_S=$(compare  $SYSTEM $MAX_S)
    MAX_IO=$(compare $IOWAIT $MAX_IO)
    MAX_ST=$(compare $IOWAIT $MAX_ST)
    MAX_I=$(compare  $IDLE   $MAX_I)
  fi
done

echo "user="$MAX_U " system="$MAX_S " iowait="$MAX_IO " idle="$MAX_I

