#!/bin/bash

exit
# Pas fini

PREFIX=640000
ORIGINALNAME=$(echo ${PREFIX}00)
NAME=$(echo ${PREFIX}01)

ID_PUBLIC=64
ID_PRIVATE=65
ID_SURETE=66

ID_ROUTAGE=70
ID_SRTM=80

FILE_ROUTAGE=04_Pistes.osm

MNT_LINUX=/media
MNT_MAC=/Volumes

VOLUME="GF-CONGO"

if [ -d ${MNT_MAC}/${VOLUME} ] ; then
	echo "[ok] MacOS X detected"
	DIR="${MNT_MAC}/${VOLUME}/Carto/01-CarteGreg"
	GARMIN="${MNT_MAC}/GARMIN"
	#MKGMAP="${MNT_MAC}/${VOLUME}/Carto/90-Softs/mkgmap-r2788/mkgmap.jar"
	MKGMAP="${MNT_MAC}/${VOLUME}/Carto/90-Softs/3_Java/mkgmap_custom/mkgmap.jar"
	#MKGMAP="/Applications/Carto/mkgmap/mkgmap.jar"
	#GMAPIBUILDER="/Applications/Carto/gmapi-builder.py"
	GMAPIBUILDER="${MNT_MAC}/${VOLUME}/Carto/90-Softs/gmapi-builder/gmapi-builder.py"
else
	if [ -d ${MNT_LINUX}/${VOLUME} ] ; then
		echo "[ok] Linux detected"
		DIR="${MNT_LINUX}/${VOLUME}/Carto/01-CarteGreg"
		GARMIN="${MNT_LINUX}/GARMIN"
		MKGMAP="${MNT_LINUX}/${VOLUME}/Carto/90-Softs/3_Java/mkgmap_custom/mkgmap.jar"
		#MKGMAP="/data_local/mkgmap-r2788-src/dist/mkgmap.jar"
		GMAPIBUILDER="${MNT_LINUX}/${VOLUME}/Carto/90-Softs/4_Python/gmapi-builder/gmapi-builder.py"
	else 
		echo "[!!] USB Drive not connected"
		exit 1;
	fi;
fi;

SRTM_SRC=$DIR/src/srtm/img
FILE_COAST=00_Coast.osm

export LANG=fr_FR.UTF-8
DATE=$(date "+%B %Y")
VERSION=$(date "+%y%m") ;



# SRTM
		#--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \

echo "SRTM data from NASA" > $DIR/scripts/license_srtm.txt

if [ ! -d ${SRTM_SRC} ] ; then mkdir ${SRTM_SRC} ; else rm -rf ${SRTM_SRC}/* ; fi ;
for f in $DIR/src/srtm/OSM_dalles/*.osm ; do
	g=$(basename $f .osm) ;
	d=$(dirname $f)
	echo "[ok] $NAME Create srtm map" $g

	java -Xmx2G -jar $MKGMAP \
	--transparent \
	--keep-going --draw-priority=$drawpriority \
	--description="[iero] "$g \
	--family-name="iero Congo" \
	--series-name="iero Congo" \
	--product-version=$VERSION \
	--mapname=$NAME --family-id=${ID_SRTM} --product-id=0 \
	--license-file=$DIR/scripts/license_srtm.txt \
	--copyright-message="SRTM data from NASA" \
	--country-name=Congo --country-abbr=CG \
	--latin1 --output-dir=$DIR/output/imgs/private $f $DIR/styles/${ID_SRTM}_SRTM.TYP 1> /dev/null; 

	cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/public/${NAME}.img
	cp $DIR/output/imgs/private/${NAME}.img ${SRTM_SRC}

	let drawpriority++ ;
	let NAME++ ;
	let nbfiles++ ;
done ;

# Create key file for waypoints
#grep "tag k='" $DIR/06_Waypoints.osm | grep -v name | grep -v source | sed s#"<tag k='"## | sed s#"' v='"#"\t"# | sed s#"' />"## |sort | uniq > $DIR/06_Waypoints.way

#--family-id=$ID --product-id=$ID \
#--style-file=$DIR/styles --style=iero \

echo "[ok] Create final maps"	

java -jar $MKGMAP --tdbfile --gmapsupp $DIR/output/imgs/private/*.img \
	--keep-going \
	--style-file=$DIR/styles --style=iero \
	--family-name="iero Congo private" \
	--series-name="iero Congo private" \
	--mapname=$ORIGINALNAME --family-id=${ID_PRIVATE} --product-id=${ID_PRIVATE} \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--output-dir=$DIR/output/gps/private 1> /dev/null ;

java -jar $MKGMAP --tdbfile --gmapsupp $DIR/output/imgs/public/*.img \
	--keep-going \
	--style-file=$DIR/styles --style=iero \
	--family-name="iero Congo public" \
	--series-name="iero Congo public" \
	--mapname=$ORIGINALNAME --family-id=${ID_PUBLIC} --product-id=${ID_PUBLIC} \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--output-dir=$DIR/output/gps/public 1> /dev/null;

java -jar $MKGMAP --tdbfile --gmapsupp $DIR/output/imgs/public/nosrtm/*.img \
	--keep-going \
	--style-file=$DIR/styles --style=iero \
	--family-name="iero Congo public nosrtm" \
	--series-name="iero Congo public nosrtm" \
	--mapname=$ORIGINALNAME --family-id=$ID --product-id=$ID \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--output-dir=$DIR/output/gps/public/nosrtm 1> /dev/null;

java -jar $MKGMAP --tdbfile --gmapsupp $DIR/output/imgs/surete/*.img \
	--keep-going \
	--style-file=$DIR/styles --style=iero \
	--family-name="iero Congo Surete" \
	--series-name="iero Congo Surete" \
	--mapname=$ORIGINALNAME --family-id=$ID --product-id=$ID \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--output-dir=$DIR/output/gps/surete 1> /dev/null;

if [ -d "$GARMIN" ] ; then
	echo "[ok] Upload map to GPS"
	cp $DIR/output/gps/private/gmapsupp.img "$GARMIN/Garmin/gmapsupp.img"
	rm -rf "$GARMIN/.Spotlight*"
	rm -rf "$GARMIN/.Trashes"
	rm -rf "$GARMIN/.fseventsd"
fi

echo "[ok] Create Basecamp maps"

cp $DIR/output/gps/private/osmmap.img $DIR/output/imgs/private
cp $DIR/output/gps/public/osmmap.img $DIR/output/imgs/public
cp $DIR/output/gps/public/nosrtm/osmmap.img $DIR/output/imgs/public/nosrtm
cp $DIR/output/gps/surete/osmmap.img $DIR/output/imgs/surete

python $GMAPIBUILDER -t $DIR/output/gps/private/osmmap.tdb -b $DIR/output/gps/private/osmmap.img -o $DIR/output/basecamp/mac/private $DIR/output/imgs/private/*.img
python $GMAPIBUILDER -t $DIR/output/gps/public/osmmap.tdb -b $DIR/output/gps/public/osmmap.img -o $DIR/output/basecamp/mac/public $DIR/output/imgs/public/*.img
python $GMAPIBUILDER -t $DIR/output/gps/public/nosrtm/osmmap.tdb -b $DIR/output/gps/public/nosrtm/osmmap.img -o $DIR/output/basecamp/mac/public/nosrtm/ $DIR/output/imgs/public/nosrtm/*.img
python $GMAPIBUILDER -t $DIR/output/gps/surete/osmmap.tdb -b $DIR/output/gps/surete/osmmap.img -o $DIR/output/basecamp/mac/surete $DIR/output/imgs/surete/*.img

# Convert for windows
cp -rf $DIR/output/basecamp/mac/private/iero\ Congo\ private.gmapi/iero\ Congo\ private.gmap $DIR/output/basecamp/win/private/
cp -rf $DIR/output/basecamp/mac/public/iero\ Congo\ public.gmapi/iero\ Congo\ public.gmap $DIR/output/basecamp/win/public/
cp -rf $DIR/output/basecamp/mac/public/nosrtm/iero\ Congo\ public\ nosrtm.gmapi/iero\ Congo\ public\ nosrtm.gmap $DIR/output/basecamp/win/public/nosrtm/
cp -rf $DIR/output/basecamp/mac/surete/iero\ Congo\ surete.gmapi/iero\ Congo\ surete.gmap $DIR/output/basecamp/win/surete/

echo "[ok] Clean GPS and temporary files"

find $DIR/output -name *.[jp]gw -exec rm  '{}' \;

if [ ! -d "$GARMIN" ] ; then
	rm -rf "$GARMIN/.Spotlight-V100"
	rm -rf "$GARMIN/.Trashes"
	rm -rf "$GARMIN/.fseventsd"
fi

