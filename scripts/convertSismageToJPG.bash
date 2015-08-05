#!/bin/bash

f=$1

echo "[ok] Working on $f"

if [ -e $f ] ; then
	echo "[!!] File not found"
	exit 1
fi

g=$(basename $f .tif) ;
h=$(dirname $f);

echo "[ok] Convert $g/${h}.tif"

gdalwarp -srcnodata 0 -s_srs EPSG:28232 -t_srs EPSG:3785 -r bilinear $h/${g}.tif $h/${g}_mercator.tif
gdalbuildvrt $h/${g}_mercator.vrt $h/${g}_mercator.tif
grep GeoTransform $h/${g}_mercator.vrt | sed s#"  <GeoTransform>  "## | sed s#"</GeoTransform>"##g \
	| awk '{ print $2, '0,' 0, $6, $1, $4 }' | sed s/,//g | sed s/" "/"\n"/g > $h/${g}_mercator.wld
rm $h/${g}_mercator.vrt
convert $h/${g}_mercator.tif $h/${g}_mercator.jpg
