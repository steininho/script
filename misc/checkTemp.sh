#!/bin/bash

# Mailto
mailto="danielhellestveit@gmail.com"
#mailto="claytonzane@gmail.com"

# Coordinates
FLEKKEFJORD_LAT=58.2984260
FLEKKEFJORD_LON=6.6727460
STORD_LAT=59.806244
STORD_LON=5.519841

# User agent for MET API
UA="TempCheckScript/1.0 email@example.com"

#get_max_temp() {
#  LAT=$1
#  LON=$2
#  curl -s -H "User-Agent: $UA" "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=$LAT&lon=$LON" | \
#    jq '[.properties.timeseries[].data.instant.details.air_temperature] | max'
#}

#FLEKK_MAX=$(get_max_temp $FLEKKEFJORD_LAT $FLEKKEFJORD_LON)
#STORD_MAX=$(get_max_temp $STORD_LAT $STORD_LON)

# Get temperatures
FLEKK_TEMP=$(curl -s -H "User-Agent: $UA" \
  "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=$FLEKKEFJORD_LAT&lon=$FLEKKEFJORD_LON" | \
  jq '.properties.timeseries[0].data.instant.details.air_temperature')

STORD_TEMP=$(curl -s -H "User-Agent: $UA" \
  "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=$STORD_LAT&lon=$STORD_LON" | \
  jq '.properties.timeseries[0].data.instant.details.air_temperature')

# Compare and write if Flekkefjord is warmer
if (( $(echo "$FLEKK_TEMP > $STORD_TEMP" | bc -l) )); then
  DIFF=$(echo "$FLEKK_TEMP - $STORD_TEMP" | bc -l)
  TIMESTAMP=$(date -Iseconds)
  LOG="
    Flekkefjord: $FLEKK_TEMP\n
    Stord: $STORD_TEMP \n\n

    Flekkefjord er i dag ${DIFF}\u00b0C varmere enn Stord.\n\n

    SUCK IT!!!\n\n

    https://danapp.steininho.com"

    echo -e $LOG  | s-nail -s "Temperatur" $mailto
else
        echo "Stord is equal to or warmer than Flekkefjord, do nothing (F: $FLEKK_TEMP, S: $STORD_TEMP)"
fi