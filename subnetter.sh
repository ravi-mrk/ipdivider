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
m=$((32-sub))
c=$((2**$m))

if [[ "$sub" -ge "24" ]]
then
    li=$((ip4+c-1))
elif [[ "$sub" -ge "16" && "$sub" -le "23" ]]
then
    li=$((ip3+c-1))
elif [[ "$sub" -ge "8" && "$sub" -le "15" ]]
then
    li=$((ip2+c-1))
elif [[ "$sub" -ge "0" && "$sub" -le "7" ]]
then
    li=$((ip1+c-1))
fi

for r in $(eval echo {$r..1} )
do
n=$((32-sub))
q=$(($c/$r))
  while [[ "$q" -le "$((2**$n))" && "$n" -gt "0" ]]
  do
    if [[ "$q" -eq "$((2**$n))" || "$q" -gt "$((2**($n-1)))" && "$n" -gt "0" ]]
    then
        p=$((2**$n))
        c=$((c-p))
        sn=$((li-c+1))
        sb=$((32-n))
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
echo "subnet=$ip1.$ip2.$((sn-p)).$ip4/sb" "network=$ip1.$ip2.$((sn-p)).$ip4" "broadcast=$ip1.$ip2.$((sn-1)).$ip4" "gateway=$ip1.$ip2.$((sn-p+1)).$ip4" "hosts=$(($p-3))"
elif [[ "$sub" -ge "8" && "$sub" -le "15" ]]
then
    v=$ip2
echo "subnet=$ip1.$((sn-p)).$ip3.$ip4/sb" "network=$ip1.$((sn-p)).$ip3.$ip4" "broadcast=$ip1.$((sn-1)).$ip3.$ip4" "gateway=$ip1.$((sn-p+1)).$ip3.$ip4" "hosts=$(($p-3))"
elif [[ "$sub" -ge "0" && "$sub" -le "7" ]]
then
    v=$ip1
echo "subnet=$((sn-p)).$ip2.$ip3.$ip4/sb" "network=$((sn-p)).$ip2.$ip3.$ip4" "broadcast=$((sn-1)).$ip2.$ip3.$ip4" "gateway=$((sn-p+1)).$ip2.$ip3.$ip4" "hosts=$(($p-3))"
fi
done
