#!/bin/bash

IP=`echo $1 | cut -d / -f1`

ip1=$(echo ${IP} | tr "." " " | awk '{ print $1 }')
ip2=$(echo ${IP} | tr "." " " | awk '{ print $2 }')
ip3=$(echo ${IP} | tr "." " " | awk '{ print $3 }')
ip4=$(echo ${IP} | tr "." " " | awk '{ print $4 }')

r=$2
d=$2
sub=`echo $1 | cut -d / -f2`

b=0

if [[ "$sub" -ge "24" ]]
then
    x=4
    m=$((32-sub))
    c=$((2**$m))
    li=$((ip$x+c-1))
elif [[ "$sub" -ge "16" && "$sub" -le "23" ]]
then
    x=3
    m=$((24-sub))
    c=$((2**$m))
    li=$((ip$x+c-1))
elif [[ "$sub" -ge "8" && "$sub" -le "15" ]]
then
    x=2
    m=$((16-sub))
    c=$((2**$m))
    li=$((ipx+c-1))
elif [[ "$sub" -ge "0" && "$sub" -le "7" ]]
then
    x=1
    m=$((8-sub))
    c=$((2**$m))
    li=$((ipi$x+c-1))
fi

for r in $(eval echo {$r..1} )
do
n=$m
q=$(($c/$r))
  while [[ "$q" -le "$((2**$n))" && "$n" -gt "0" ]]
  do
    if [[ "$q" -eq "$((2**$n))" || "$q" -gt "$((2**($n-1)))" && "$n" -gt "0" ]]
    then
        p=$((2**$n))
        c=$((c-p))
        sn=$((li-c+1))
        sb=$((8*$x-n))
for j in $(eval echo {$n..1} )
do
s=$((2**($j-1)))
b=$((b+s))
done
    fi
  (( n-- ))
  done
d=$d-$r
if [[ "$sub" -ge "24" ]]
then
    v=$ip4
    echo "subnet=$ip1.$ip2.$ip3.$((sn-p))/$sb" "network=$ip1.$ip2.$ip3.$((sn-p))" "broadcast=$ip1.$ip2.$ip3.$((sn-1))" "gateway=$ip1.$ip2.$ip3.$((sn-p+1))" "hosts=$(($p-3))"
elif [[ "$sub" -ge "16" && "$sub" -le "23" ]]
then
    v=$ip3
echo "subnet=$ip1.$ip2.$((sn-p)).$ip4/$sb" "network=$ip1.$ip2.$((sn-p)).$ip4" "broadcast=$ip1.$ip2.$((sn-1)).255" "gateway=$ip1.$ip2.$((sn-p+1)).$ip4" "hosts=$(($p-3))"
elif [[ "$sub" -ge "8" && "$sub" -le "15" ]]
then
    v=$ip2
echo "subnet=$ip1.$((sn-p)).$ip3.$ip4/$sb" "network=$ip1.$((sn-p)).$ip3.$ip4" "broadcast=$ip1.$((sn-1)).255.255" "gateway=$ip1.$((sn-p+1)).$ip3.$ip4" "hosts=$(($p-3))"
elif [[ "$sub" -ge "0" && "$sub" -le "7" ]]
then
    v=$ip1
echo "subnet=$((sn-p)).$ip2.$ip3.$ip4/$sb" "network=$((sn-p)).$ip2.$ip3.$ip4" "broadcast=$((sn-1)).255.255.255" "gateway=$((sn-p+1)).$ip2.$ip3.$ip4" "hosts=$(($p-3))"
fi
done
