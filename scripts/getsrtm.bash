#!/bin/bash

SRC=/Volumes/GF-CONGO/Carto/90-Softs/Srtm2Osm2/Srtm2Osm.exe
DIR=/Volumes/GF-CONGO/Carto/01-CarteGreg

if [ ! -x $SRC ] ; then
        echo "[!!] Srtm not installed in $SRC"
	exit 1;
fi;


if [ ! -d $DIR/srtm ] ; then mkdir $DIR/srtm ; else rm -rf $DIR/output/srtm/* ; fi ;


# Rang A
echo "[ok] Getting A row"

#mono $SRC -bounds1 -5 11 -4 12 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_a0.osm 
#mono $SRC -bounds1 -5 12 -4 13 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_a1.osm
#mono $SRC -bounds1 -5 13 -4 14 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_a2.osm
#mono $SRC -bounds1 -5 14 -4 15 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_a3.osm
#mono $SRC -bounds1 -5 15 -4 16 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_a4.osm

# Rang B
echo "[ok] Getting B row"

#mono $SRC -bounds1 -4 11 -3 12 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_b0.osm
#mono $SRC -bounds1 -4 12 -3 13 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_b1.osm
#mono $SRC -bounds1 -4 13 -3 14 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_b2.osm
#mono $SRC -bounds1 -4 14 -3 15 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_b3.osm
#mono $SRC -bounds1 -4 15 -3 16 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_b4.osm
#mono $SRC -bounds1 -4 16 -3 17 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_b5.osm

# Rang C
echo "[ok] Getting C row"

#mono $SRC -bounds1 -3 11 -2 12 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_c0.osm
#mono $SRC -bounds1 -3 12 -2 13 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_c1.osm
#mono $SRC -bounds1 -3 13 -2 14 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_c2.osm
#mono $SRC -bounds1 -3 14 -2 15 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_c3.osm
#mono $SRC -bounds1 -3 15 -2 16 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_c4.osm
#mono $SRC -bounds1 -3 16 -2 17 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_c5.osm

# Rang D
echo "[ok] Getting D row"

#mono $SRC -bounds1 -2 12 -1 13 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_d1.osm
#mono $SRC -bounds1 -2 13 -1 14 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_d2.osm
#mono $SRC -bounds1 -2 14 -1 15 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_d3.osm
#mono $SRC -bounds1 -2 15 -1 16 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_d4.osm
#mono $SRC -bounds1 -2 16 -1 17 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_d5.osm
#mono $SRC -bounds1 -2 17 -1 18 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_d6.osm

# Rang E
echo "[ok] Getting E row"

#mono $SRC -bounds1 -1 13 0 14 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_e2.osm
#mono $SRC -bounds1 -1 14 0 15 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_e3.osm
#mono $SRC -bounds1 -1 15 0 16 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_e4.osm
#mono $SRC -bounds1 -1 16 0 17 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_e5.osm
#mono $SRC -bounds1 -1 17 0 18 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_e6.osm

# Rang F
echo "[ok] Getting F row"

#mono $SRC -bounds1 0 13 1 14 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_f2.osm
#mono $SRC -bounds1 0 14 1 15 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_f3.osm
#mono $SRC -bounds1 0 15 1 16 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_f4.osm
#mono $SRC -bounds1 0 16 1 17 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_f5.osm
#mono $SRC -bounds1 0 17 1 18 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_f6.osm

# Rang G
echo "[ok] Getting G row"

#mono $SRC -bounds1 1 13 2 14 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_g2.osm
#mono $SRC -bounds1 1 14 2 15 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_g3.osm
#mono $SRC -bounds1 1 15 2 16 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_g4.osm
#mono $SRC -bounds1 1 16 2 17 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_g5.osm
#mono $SRC -bounds1 1 17 2 18 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_g6.osm
#mono $SRC -bounds1 1 18 2 19 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_g7.osm

# Rang H
echo "[ok] Getting H row"

#mono $SRC -bounds1 2 13 3 14 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_h2.osm
mono $SRC -bounds1 2 14 3 15 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_h3.osm
mono $SRC -bounds1 2 15 3 16 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_h4.osm
mono $SRC -bounds1 2 16 3 17 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_h5.osm
mono $SRC -bounds1 2 17 3 18 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_h6.osm
mono $SRC -bounds1 2 18 3 19 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_h7.osm

# Rang I
echo "[ok] Getting I row"

mono $SRC -bounds1 3 16 4 17 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_i5.osm
mono $SRC -bounds1 3 17 4 18 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_i6.osm
mono $SRC -bounds1 3 18 4 19 -step 25 -cat 500 100 -large -o $DIR/srtm/srtm_i7.osm

