#!/bin/bash

organ_name="台中弗傳"
organ_region="taichung"
organ_abbre="fcts"
cp config.json config1.json
sed -i -e s/organ_name/$organ_name/g config1.json
sed -i -e s/organ_region/$organ_region/g config1.json
sed -i -e s/organ_abbre/$organ_abbre/g config1.json
