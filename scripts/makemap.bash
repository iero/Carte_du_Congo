#!/bin/bash

PREFIX=640000
ORIGINALNAME=$(echo ${PREFIX}00)
NAME=$(echo ${PREFIX}01)

ID_PUBLIC=64
ID_PRIVATE=65
ID_SURETE=66

ID_ROUTAGE=70
ID_SRTM=80

FILE_ROUTAGE=04_Pistes.osm

DIR=/Volumes/GF-CONGO/Carto/01-CarteGreg
#DIR=/Users/iero/Documents/GPS/Congo/Cartes/01-CarteGreg
JAR=/Applications/Carto/mkgmap/mkgmap.jar
GARMIN=/Volumes/GARMIN
#MAPERITIVE="/Applications/Carto/Maperitive/Maperitive.exe"
#INKSCAPE="/Applications/Carto/Inkscape.app/Contents/Resources/bin/inkscape"
GMAPIBUILDER="/Applications/Carto/gmapi-builder.py"
#TILER=/Applications/Carto/tiler.php

SRTM_SRC=$DIR/src/srtm/img
FILE_COAST=00_Coast.osm

export LANG=fr_FR.UTF-8
DATE=$(date "+%B %Y")
VERSION=$(date "+%y%m") ;

if [ ! -d "$GARMIN" ] ; then
	echo "[!!] Garmin not connected"
	#exit 1 ;
fi ;

if [ ! -d $DIR/output ] ; then mkdir $DIR/output ; else rm -rf $DIR/output/* ; fi ;
if [ ! -d $DIR/output/imgs ] ; then mkdir $DIR/output/imgs ; else rm -f $DIR/output/imgs/* ; fi ;
mkdir $DIR/output/imgs/public $DIR/output/imgs/public/nosrtm $DIR/output/imgs/private $DIR/output/imgs/surete
if [ ! -d $DIR/output/gps ] ; then mkdir $DIR/output/gps ; else rm -f $DIR/output/gps/* ; fi ;
mkdir $DIR/output/gps/public $DIR/output/gps/public/nosrtm $DIR/output/gps/private $DIR/output/gps/surete
if [ ! -d $DIR/output/basecamp ] ; then mkdir $DIR/output/basecamp ; else rm -f $DIR/output/basecamp/* ; fi ;
mkdir $DIR/output/basecamp/public $DIR/output/basecamp/public/nosrtm $DIR/output/basecamp/private $DIR/output/basecamp/surete

nbfiles=0 ;
drawpriority=1 ;

echo "Generating maps of Congo - $DATE - Severine and Greg FABRE - http://www.iero.org"
echo "Congo - $DATE - Severine and Greg FABRE http://www.iero.org" > $DIR/scripts/license.txt

# Routage

f=$DIR/src/public/${FILE_ROUTAGE}
if [ ! -d $f ] ; then
	g=$(basename $f .osm) ;
	d=$(dirname $f)
	echo "[ok] $NAME Create routage map" $g
	java -jar $JAR \
	--net --route \
	--keep-going --draw-priority=$drawpriority \
	--remove-short-arcs \
	--description="[iero] "$g \
	--family-name="iero Congo" \
	--series-name="iero Congo" \
	--mapname=${NAME} --family-id=${ID_PUBLIC} --product-id=0 \
	--country-name=Congo --country-abbr=CG \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--latin1 --output-dir=$DIR/output/imgs/private $f $DIR/styles/${ID_ROUTAGE}_Routage.TYP 1> /dev/null; 
	
	cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/public/${NAME}.img
	cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/public/nosrtm/${NAME}.img
	cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/surete/${NAME}.img

	let drawpriority++ ;
	let NAME++ ;
	let nbfiles++ ;
fi;

# Coast 

f=$DIR/src/misc/${FILE_COAST}
if [ ! -d $f ] ; then
	g=$(basename $f .osm) ;
	d=$(dirname $f)
	echo "[ok] $NAME Create coastal map" $g	
	java -jar $JAR \
	--remove-short-arcs --generate-sea:extend-sea-sectors,close-gaps=50000 \
	--keep-going --draw-priority=$drawpriority \
	--description="[iero] "$g \
	--family-name="iero Congo" \
	--series-name="iero Congo" \
	--mapname=$NAME --family-id=${ID_PUBLIC} --product-id=0 \
	--style-file=$DIR/styles --style=iero \
	--country-name=Congo --country-abbr=CG \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--output-dir=$DIR/output/imgs/private $f 1> /dev/null;
	
	cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/public/${NAME}.img
	cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/public/nosrtm/${NAME}.img
	cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/surete/${NAME}.img

	let drawpriority++ ;
	let NAME++ ;
	let nbfiles++ ;
fi;

# Public

for f in $DIR/src/public/*.osm ; do 
	g=$(basename $f .osm) ;
	d=$(dirname $f)

	echo "[ok] $NAME Create public map" $g	
	java -jar $JAR \
	--transparent \
	--keep-going --draw-priority=$drawpriority \
	--remove-short-arcs \
	--description="[iero] "$g \
	--family-name="iero Congo" \
	--series-name="iero Congo" \
	--mapname=$NAME --family-id=${ID_PUBLIC} --product-id=0 \
	--country-name=Congo --country-abbr=CG \
	--style-file=$DIR/styles --style=iero \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--latin1 --output-dir=$DIR/output/imgs/private $f 1> /dev/null; 

	cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/public/${NAME}.img
	cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/public/nosrtm/${NAME}.img
	cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/surete/${NAME}.img

	let NAME++ ;
	let nbfiles++ ;
	let drawpriority++ ;
done

# Private

for f in $DIR/src/private/*.osm ; do
	g=$(basename $f .osm) ;
	d=$(dirname $f)

	echo "[ok] $NAME Create private map" $g	
	java -jar $JAR \
	--transparent \
	--keep-going --draw-priority=$drawpriority \
	--remove-short-arcs \
	--description="[iero] "$g \
	--family-name="iero Congo" \
	--series-name="iero Congo" \
	--mapname=$NAME --family-id=${ID_PRIVATE} --product-id=$ID \
	--country-name=Congo --country-abbr=CG \
	--style-file=$DIR/styles --style=iero \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--latin1 --output-dir=$DIR/output/imgs/private $f 1> /dev/null; 

	let NAME++ ;
	let nbfiles++ ;
	let drawpriority++ ;
done

for f in $DIR/src/surete/*.osm ; do
	g=$(basename $f .osm) ;
	d=$(dirname $f)

	echo "[ok] $NAME Create surete map" $g	
	java -jar $JAR \
	--transparent \
	--keep-going --draw-priority=$drawpriority \
	--remove-short-arcs \
	--description="[iero] "$g \
	--family-name="iero Congo" \
	--series-name="iero Congo" \
	--mapname=$NAME --family-id=$ID --product-id=$ID \
	--country-name=Congo --country-abbr=CG \
	--style-file=$DIR/styles --style=iero \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--latin1 --output-dir=$DIR/output/imgs/private $f 1> /dev/null; 

	cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/surete/${NAME}.img
	
	let NAME++ ;
	let nbfiles++ ;
	let drawpriority++ ;
done

# SRTM
		#--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \

echo "SRTM from NASA" > $DIR/scripts/license_srtm.txt

if [ -d ${SRTM_SRC} ] ; then
	echo "[ok] Copy already generated srtm maps"
	cp ${SRTM_SRC}/*  $DIR/output/imgs/private/
	cp ${SRTM_SRC}/*  $DIR/output/imgs/public/
else
	mkdir ${SRTM_SRC}
	for f in $DIR/src/srtm/OSM_dalles/*.osm ; do
		g=$(basename $f .osm) ;
		d=$(dirname $f)
		echo "[ok] $NAME Create srtm map" $g
	
		java -Xmx1G -jar $JAR \
		--transparent \
		--keep-going --draw-priority=$drawpriority \
		--remove-short-arcs \
		--description="[iero] "$g \
		--family-name="iero Congo" \
		--series-name="iero Congo" \
		--product-version=$VERSION \
		--mapname=$NAME --family-id=${ID_SRTM} --product-id=0 \
		--license-file=$DIR/scripts/license_srtm.txt \
		--country-name=Congo --country-abbr=CG \
		--latin1 --output-dir=$DIR/output/imgs/private $f $DIR/styles/${ID_SRTM}_SRTM.TYP 1> /dev/null; 

		cp $DIR/output/imgs/private/${NAME}.img $DIR/output/imgs/public/${NAME}.img
		cp $DIR/output/imgs/private/${NAME}.img ${SRTM_SRC}

		let drawpriority++ ;
		let NAME++ ;
		let nbfiles++ ;
	done ;
fi ;

# Create key file for waypoints
#grep "tag k='" $DIR/06_Waypoints.osm | grep -v name | grep -v source | sed s#"<tag k='"## | sed s#"' v='"#"\t"# | sed s#"' />"## |sort | uniq > $DIR/06_Waypoints.way

#--family-id=$ID --product-id=$ID \
#--style-file=$DIR/styles --style=iero \

echo "[ok] Create final maps"	
java -jar $JAR --tdbfile --gmapsupp $DIR/output/imgs/private/*.img \
	--keep-going \
	--style-file=$DIR/styles --style=iero \
	--family-name="iero Congo private" \
	--series-name="iero Congo private" \
	--mapname=$ORIGINALNAME --family-id=${ID_PRIVATE} --product-id=${ID_PRIVATE} \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--output-dir=$DIR/output/gps/private 1> /dev/null ;

java -jar $JAR --tdbfile --gmapsupp $DIR/output/imgs/public/*.img \
	--keep-going \
	--style-file=$DIR/styles --style=iero \
	--family-name="iero Congo public" \
	--series-name="iero Congo public" \
	--mapname=$ORIGINALNAME --family-id=${ID_PUBLIC} --product-id=${ID_PUBLIC} \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--output-dir=$DIR/output/gps/public 1> /dev/null;

java -jar $JAR --tdbfile --gmapsupp $DIR/output/imgs/public/nosrtm/*.img \
	--keep-going \
	--style-file=$DIR/styles --style=iero \
	--family-name="iero Congo public nosrtm" \
	--series-name="iero Congo public nosrtm" \
	--mapname=$ORIGINALNAME --family-id=$ID --product-id=$ID \
	--license-file=$DIR/scripts/license.txt \
	--copyright-message="[iero.org] Congo $DATE   Severine et Greg FABRE" \
	--product-version=$VERSION \
	--output-dir=$DIR/output/gps/public/nosrtm 1> /dev/null;

java -jar $JAR --tdbfile --gmapsupp $DIR/output/imgs/surete/*.img \
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

python $GMAPIBUILDER -t $DIR/output/gps/private/osmmap.tdb -b $DIR/output/gps/private/osmmap.img -o $DIR/output/basecamp/private $DIR/output/imgs/private/*.img
python $GMAPIBUILDER -t $DIR/output/gps/public/osmmap.tdb -b $DIR/output/gps/public/osmmap.img -o $DIR/output/basecamp/public $DIR/output/imgs/public/*.img
python $GMAPIBUILDER -t $DIR/output/gps/public/nosrtm/osmmap.tdb -b $DIR/output/gps/public/nosrtm/osmmap.img -o $DIR/output/basecamp/public/nosrtm/ $DIR/output/imgs/public/nosrtm/*.img
python $GMAPIBUILDER -t $DIR/output/gps/surete/osmmap.tdb -b $DIR/output/gps/surete/osmmap.img -o $DIR/output/basecamp/surete $DIR/output/imgs/surete/*.img

# Convert for windows

#cp -rf $DIR/output/basecamp/private/iero\ Congo.gmapi/iero\ Congo.gmap $DIR/output/basecamp/private/
#cp -rf $DIR/output/basecamp/public/iero\ Congo.gmapi/iero\ Congo.gmap $DIR/output/basecamp/public/
#cp -rf $DIR/output/basecamp/public/nosrtm/iero\ Congo.gmapi/iero\ Congo.gmap $DIR/output/basecamp/public/nosrtm
#cp -rf $DIR/output/basecamp/surete/iero\ Congo.gmapi/iero\ Congo.gmap $DIR/output/basecamp/surete/

echo "[ok] Populate database"

OSM2PGSQL="osm2pgsql";
OSM2PGSQL_OPTIONS="--slim --database congo"
#Misc
${OSM2PGSQL} --prefix planet_osm_coast -S $DIR/styles/osm2pgsql/coast.style --keep-coastlines ${OSM2PGSQL_OPTIONS} $DIR/src/misc/00_CoastOneLine.osm
${OSM2PGSQL} --prefix planet_osm_legend -S $DIR/styles/osm2pgsql/legende.style ${OSM2PGSQL_OPTIONS} $DIR/src/misc/20_Legende.osm
#Private
${OSM2PGSQL} --prefix planet_osm_wells -S $DIR/styles/osm2pgsql/wells.style ${OSM2PGSQL_OPTIONS} $DIR/src/private/31_Wells.osm
${OSM2PGSQL} --prefix planet_osm_lignes2donshore -S $DIR/styles/osm2pgsql/lignes2donshore.style ${OSM2PGSQL_OPTIONS} $DIR/src/private/33_Lignes2Donshore.osm
#Surete
${OSM2PGSQL} --prefix planet_osm_surete -S $DIR/styles/osm2pgsql/surete.style ${OSM2PGSQL_OPTIONS} $DIR/src/surete/40_SitesTEPC.osm

for f in $DIR/src/public/*.osm ; do 
	g=$(basename $f .osm) ;
	h=$(echo $g | sed 's/[0-9]*_//g'| sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/")
	echo "[ok] Add $h to sql database"
	if [ -e $DIR/styles/osm2pgsql/$h.style ] ; then
		OSM2PGSQL_STYLE="-S $DIR/styles/osm2pgsql/$h.style" ;
	else
		OSM2PGSQL_STYLE="-S $DIR/styles/osm2pgsql.style" ;
	fi ;
	#psql -d congo -c "drop table if exists planet_osm_$h_line;
	#psql -d congo -c "drop table if exists planet_osm_$h_point;
	#psql -d congo -c "drop table if exists planet_osm_$h_polygon;
	#psql -d congo -c "drop table if exists planet_osm_$h_roads;
	#${OSM2PGSQL} --prefix planet_osm_$h --append ${OSM2PGSQL_OPTIONS} $f
	${OSM2PGSQL} --prefix planet_osm_$h ${OSM2PGSQL_STYLE} ${OSM2PGSQL_OPTIONS} $f
done;

# SRTM

#for f in $DIR/src/srtm/*.osm ; do 
#	g=$(basename $f .osm) ;
#	h=$(echo $g | sed 's/_//g')
#	echo "[ok] Add srtm $h to sql database"
#	${OSM2PGSQL} --prefix planet_osm_srtm$h ${OSM2PGSQL_OPTIONS} $f
#done;

echo "[ok] Clean GPS and temporary files"

find $DIR/output -name *.[jp]gw -exec rm  '{}' \;

if [ ! -d "$GARMIN" ] ; then
	rm -rf "$GARMIN/.Spotlight-V100"
	rm -rf "$GARMIN/.Trashes"
	rm -rf "$GARMIN/.fseventsd"
fi


# Create ECW for TomTom

MAPNIK_MAP_FILE="$DIR/src/misc/Congo.xml"
IMG_FILES="/Users/iero/Documents/MapBox/project/Congo/"
cat ${MAPNIK_MAP_FILE} | sed s#file=\"pngall#file=\"${IMG_FILES}/pngall#g | \
	sed s#file=\"svgall#file=\"${IMG_FILES}/svgall#g | \
	sed s#file=\"svg#file=\"${IMG_FILES}/svg#g > ${MAPNIK_MAP_FILE}.corrected

if [ ! -d $DIR/output/tomtom ] ; then mkdir $DIR/output/tomtom ; else rm -rf $DIR/output/tomtom/* ; fi ;
for i in $(seq -w 12 17) ; do
	mkdir $DIR/output/tomtom/$i_iero_Congo
done

$DIR/scripts/generate_mapnik.py --dir $DIR --zmin 12 --zmax 17 




gdalwarp -s_srs "EPSG:900913" -t_srs "EPSG:4326" $DIR/output_tilemill/Congo.tif $DIR/output_tilemill/Congo.gtif
#gdal_translate -of ECW -co "TARGET=90" -co "DATUM=WGS84" -co "PROJ=GEODETIC" $DIR/output_tilemill/Congo.gtif $DIR/output_tilemill/Congo.ecw
gdal_translate -of ECW -co "DATUM=WGS84" -co "PROJ=GEODETIC" $DIR/output_tilemill/Congo.gtif $DIR/output_tilemill/Congo.ecw

exit

echo "[ok] Create paper maps"

if [ ! -d $DIR/output/roadbook ] ; then mkdir $DIR/output/roadbook ; else rm -f $DIR/output/roadbook/* ; fi ;
mkdir $DIR/output/roadbook/pdf $DIR/output/roadbook/svg $DIR/output/roadbook/png
if [ ! -d $DIR/output/papermaps ] ; then mkdir $DIR/output/papermaps ; else rm -f $DIR/output/papermaps/* ; fi ;
mkdir $DIR/output/papermaps/general $DIR/output/papermaps/specific $DIR/output/papermaps/securite

if [ ! -x /usr/bin/mono ] ; then
	echo "[!!] Mono not installed"
else
	mono $MAPERITIVE -exitafter $DIR/scripts/iero-mac.mscript 2>&1 > /dev/null

	export LANG=fr_FR.UTF-8

	for f in $(find $DIR/output -name *.svg) ; do
		$DIR/scripts/repairsvg.bash $f
		d=$(dirname $f) ;
		g=$(basename $f .svg) ;
		$INKSCAPE $f --export-dpi=150 --export-pdf=$d/$g.pdf 2>&1 > /dev/null
	done ;
fi ;

#mv $DIR/output/roadbook/*.png $DIR/output/roadbook/*.kml $DIR/output/roadbook/*.map $DIR/output/roadbook/png
mv $DIR/output/roadbook/*.svg $DIR/output/roadbook/svg
mv $DIR/output/roadbook/*.pdf $DIR/output/roadbook/pdf

echo "[ok] Create iPad map"
if [ ! -x $TILER ] ; then
	echo "[!!] Tiler not installed"
else
	php $TILER $DIR/output/roadbook/png/ $DIR/output/roadbook/iPad 
fi

