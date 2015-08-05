#!/bin/bash

DIR=/media/GF-CONGO/Carto/01-CarteGreg/scripts
directory=$1

rm -f ${directory}.length

for f in $(find $directory -type f -iname *.gpx | grep -v "/\.") ; do
	d=$(${DIR}/gpxlen.py $f)
	echo total $f : $d
done

