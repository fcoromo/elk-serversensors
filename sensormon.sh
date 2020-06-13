#!/bin/bash

es_url=elastic
number=$RANDOM;
let "number %= 9";
let "number = number + 1";
range=10;
for i in {1..18}; do
  r=$RANDOM;
  let "r %= $range";
  number="$number""$r";
done;


# Get Sensor info

cpufan=$(sensors it8603-isa-0290  | grep fan1 | awk '{ print $2 }')
casefan=$(sensors it8603-isa-0290  | grep fan2 | awk '{ print $2 }')
mboardtemp=$(sensors it8603-isa-0290  | grep temp3 | awk '{ print $2 }'| sed -s 's/°C//g' | sed -s 's/+//g')

cpucase=$(sensors coretemp-isa-0000 | grep Package | awk '{ print $4 }'| sed -s 's/°C//g' | sed -s 's/+//g')
core0temp=$(sensors coretemp-isa-0000 | grep "Core 0:" | awk '{ print $3 }'| sed -s 's/°C//g' | sed -s 's/+//g')
core1temp=$(sensors coretemp-isa-0000 | grep "Core 1:" | awk '{ print $3 }'| sed -s 's/°C//g' | sed -s 's/+//g')
core2temp=$(sensors coretemp-isa-0000 | grep "Core 2:" | awk '{ print $3 }'| sed -s 's/°C//g' | sed -s 's/+//g')
core3temp=$(sensors coretemp-isa-0000 | grep "Core 3:" | awk '{ print $3 }'| sed -s 's/°C//g' | sed -s 's/+//g')

datestring=`date -u +%m.%Y`
timestamp=`date -u +"%Y-%m-%dT%T.%6NZ"`


json=$(echo "{\"CPUFAN\":$cpufan,\"CASEFAN\":$casefan,\"MBOARDTEMP\":$mboardtemp,\"CPUCASE\":$cpucase,\"CORE0TEMP\":$core0temp,\"CORE1TEMP\":$core1temp,\"CORE2TEMP\":$core2temp,\"CORE3TEMP\":$core3temp,\"timestamp\":\"$timestamp\"}")

#echo $number
#echo $json
echo "
curl -XPUT -H 'Content-Type: application/json' http://\"$es_url\":9200/serversensors-\"$datestring\"/test/\"$number\" -d\"$json\"
"
echo ""

curl -XPUT -H 'Content-Type: application/json' http://"$es_url":9200/serversensors-"$datestring"/test/"$number" -d"$json"

