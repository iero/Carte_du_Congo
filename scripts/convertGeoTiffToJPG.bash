#!/bin/bash

f=$1
epsg=$2

echo "[ok] Working on $f"

if [ ! -r $f ] ; then
	echo "[!!] File not found"
	exit 1
fi

g=$(basename $f .tif) ;
h=$(dirname $f);
i=$(echo $g |sed s/${epsg}/4326/)

echo "[ok] Convert ${g}/${h}.tif to ${i} jpg"

gdalwarp -srcnodata 0 -s_srs EPSG:28232 -t_srs EPSG:4326 -r bilinear $h/${g}.tif $h/${i}.tif
gdalbuildvrt $h/${g}.tmp $h/${i}.tif
grep GeoTransform $h/${g}.tmp | sed s#"  <GeoTransform>  "## | sed s#"</GeoTransform>"##g \
	| awk '{ print $2, '0,' 0, $6, $1, $4 }' | sed s/,//g | sed s/" "/"\n"/g > $h/${i}.wld
convert $h/${i}.tif $h/${i}.jpg
mv $h/${i}.tif $h/${i}.tmp
gdal_translate -co compress=lzw $h/${i}.tmp $h/${i}.tif
rm $h/${g}.tmp
rm $h/${i}.tmp
