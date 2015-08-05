#!/bin/bash

# Create ECW for TomTom

DIR=$1

ZMIN=$2;
ZMAX=$3;

MAPNIK_MAP_FILE="$DIR/src/misc/Congo.xml"
IMG_FILES="/Users/iero/Documents/MapBox/project/Congo/"
cat ${MAPNIK_MAP_FILE} | sed s#file=\"pngall#file=\"${IMG_FILES}/pngall#g | \
	sed s#file=\"svgall#file=\"${IMG_FILES}/svgall#g | \
	sed s#file=\"svg#file=\"${IMG_FILES}/svg#g | \
	grep -v Ubuntu > ${MAPNIK_MAP_FILE}.corrected

if [ ! -d $DIR/output/tomtom ] ; then mkdir $DIR/output/tomtom ; else rm -rf $DIR/output/tomtom/* ; fi ;
for i in $(seq -w $ZMIN $ZMAX) ; do
	mkdir $DIR/output/tomtom/${i}_iero_Congo
done

$DIR/scripts/generate_tomtom.py --dir $DIR --zmin $ZMIN --zmax $ZMAX 


# Todo : virer les plaques de mer dans les zoom

GDAL=/Library/Frameworks/GDAL.framework/Programs

a=0;
for i in $(seq -w $ZMIN $ZMAX) ; do
	for f in $(find $DIR/output/tomtom$i -name *.png) ; do 
		g=$(basename $f .png) ;
		h=$(dirname $f);
		$GDAL/gdalwarp -s_srs "EPSG:900913" -t_srs "EPSG:4326" $h/$g.png $DIR/output/tomtom/${i}_iero_Congo/iero_$i_$a.tif
		$GDAL/gdal_translate -of ECW -expand rgb -co "TARGET=90" -co "DATUM=WGS84" -co "PROJ=GEODETIC" $DIR/output/tomtom/${i}_iero_Congo/iero_$i_$a.tif $DIR/output/tomtom/${i}_iero_Congo/iero_$i_$a.ecw
		rm -f $DIR/output/tomtom/${i}_iero_Congo/iero_$i_$a.tif
               rm -f $DIR/output/tomtom/${i}_iero_Congo/iero_$i_$a.ecw.aux.xml
		let a++;
	done
	rm -rf $DIR/output/tomtom${i}
done

#gdalwarp -s_srs "EPSG:900913" -t_srs "EPSG:4326" $DIR/output_tilemill/Congo.tif $DIR/output_tilemill/Congo.gtif
#gdal_translate -of ECW -co "TARGET=90" -co "DATUM=WGS84" -co "PROJ=GEODETIC" $DIR/output_tilemill/Congo.gtif $DIR/output_tilemill/Congo.ecw
#gdal_translate -of ECW -co "DATUM=WGS84" -co "PROJ=GEODETIC" $DIR/output_tilemill/Congo.gtif $DIR/output_tilemill/Congo.ecw

exit

