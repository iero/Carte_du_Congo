#!/bin/bash

MNT_LINUX=/media
MNT_MAC=/Volumes

VOLUME="GF-CONGO"


if [ -d ${MNT_MAC}/${VOLUME} ] ; then
	echo "[ok] MacOS X detected"
	DIR=${MNT_MAC}/${VOLUME}/Carto/01-CarteGreg
else
	if [ -d ${MNT_LINUX}/${VOLUME} ] ; then
		echo "[ok] Linux detected"
		DIR=${MNT_LINUX}/${VOLUME}/Carto/01-CarteGreg
	else 
		echo "[!!] USB Drive not connected"
		exit 1;
	fi;
fi;

export LANG=fr_FR.UTF-8

echo "[ok] Populate database"

if [ ! -d ${MNT_MAC}/${VOLUME} ] ; then
	echo "[!!] Not on a mac !"
	exit 1;
fi;

OSM2PGSQL="osm2pgsql";
OSM2PGSQL_OPTIONS="--slim --database congo"

RW=${DIR}/scripts/rewriteOSMfile.bash

#Miscellaneous

# Generate compatible files
${RW} ${DIR}/src/misc/00_CoastOneLine.osm ${DIR}/src/misc/00_CoastOneLine.2pgsql
${OSM2PGSQL} --prefix coast -S $DIR/styles/osm2pgsql/coast.style --keep-coastlines ${OSM2PGSQL_OPTIONS} $DIR/src/misc/00_CoastOneLine.2pgsql
rm ${DIR}/src/misc/00_CoastOneLine.2pgsql

#${OSM2PGSQL} --prefix legend -S $DIR/styles/osm2pgsql/legende.style ${OSM2PGSQL_OPTIONS} $DIR/src/misc/20_Legende.osm
#Private
#${OSM2PGSQL} --prefix wells -S $DIR/styles/osm2pgsql/wells.style ${OSM2PGSQL_OPTIONS} $DIR/src/private/31_Wells.osm
#${OSM2PGSQL} --prefix lignes2donshore -S $DIR/styles/osm2pgsql/lignes2donshore.style ${OSM2PGSQL_OPTIONS} $DIR/src/private/33_Lignes2Donshore.osm

#Surete
${RW} ${DIR}/src/surete/40_SitesTEPC.osm ${DIR}/src/surete/40_SitesTEPC.2pgsql
${OSM2PGSQL} --prefix surete -S $DIR/styles/osm2pgsql/surete.style ${OSM2PGSQL_OPTIONS} $DIR/src/surete/40_SitesTEPC.2pgsql
rm ${DIR}/src/surete/40_SitesTEPC.2pgsql

for f in $DIR/src/public/*.osm ; do 
	g=$(basename $f .osm) ;
	h=$(echo $g | sed 's/[0-9]*_//g'| sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/")
	echo "[ok] Add $h to sql database"
	if [ -e $DIR/styles/osm2pgsql/$h.style ] ; then
		OSM2PGSQL_STYLE="-S $DIR/styles/osm2pgsql/$h.style" ;
	else
		OSM2PGSQL_STYLE="-S $DIR/styles/osm2pgsql.style" ;
	fi ;

	${RW} ${DIR}/src/public/${g}.osm ${DIR}/src/public/${g}.2pgsql
	${OSM2PGSQL} --prefix $h ${OSM2PGSQL_STYLE} ${OSM2PGSQL_OPTIONS} ${DIR}/src/public/${g}.2pgsql
	rm ${DIR}/src/public/${g}.2pgsql
done;

# SRTM

#for f in $DIR/src/srtm/*.osm ; do 
#	g=$(basename $f .osm) ;
#	h=$(echo $g | sed 's/_//g')
#	echo "[ok] Add srtm $h to sql database"
#	${OSM2PGSQL} --prefix planet_osm_srtm$h ${OSM2PGSQL_OPTIONS} $f
#done;


