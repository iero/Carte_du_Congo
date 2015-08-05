#!/bin/bash

DIR=$1

toReplace="<g id=\"map_grid__latitude\""
text="                <g id=\"map_pages\" style=\"stroke:#B0B0B0;stroke-width:0.5;font-family:Tahoma;font-size:18px\" inkscape:groupmode=\"layer\" inkscape:label=\"map pages\">\n"

for carte in {a..z} ; do
	for dec in {0..9} ; do
		for unit in {0..9} ; do
			newText=$text;

			file=${carte}${dec}${unit}.svg
			if [ ! -e $DIR/$file ] ; then continue; 
			else echo "Rebuild map $file"; fi;

			width=$(cat $DIR/$file | grep "<rect x=\"0\" y=\"0\"" | head -n 1 | \
			        sed s#"<rect x=\"0\" y=\"0\""## | sed s#" height.*$"## | sed s#".*width=\""## | sed s/\"//)
			height=$(cat $DIR/$file | grep "<rect x=\"0\" y=\"0\"" | head -n 1 | \
			        sed s#"<rect x=\"0\" y=\"0\""## | sed s#".*height=\""## |sed s/\".*//)

			placeX=$(echo $width / 2 | bc)		
			placeY=$(echo $height / 2 | bc)		

			gNum=$(echo ${dec}${unit} -1 | bc);
			dNum=$(echo ${dec}${unit} +1 | bc);
			if [ $gNum -lt 10 ] ; then gNum="0"$gNum ; fi ;
			if [ $dNum -lt 10 ] ; then dNum="0"$dNum ; fi ;
			gFile=${carte}${gNum}.svg
			dFile=${carte}${dNum}.svg

			hLet=$(echo $carte | tr 'a-y' 'b-z')			
			bLet=$(echo $carte | tr 'b-z' 'a-y')			
			
			if [ $carte != $hLet ] ; then
				hFile=${hLet}${dec}${unit}.svg
			else
				hFile="nofile"
			fi;

			if [ $carte != $bLet ] ; then
				bFile=${bLet}${dec}${unit}.svg
			else
				bFile="nofile"
			fi;

			#Carte a gauche
			if  [ -e $DIR/${gFile} ] ; then
				echo "- Left map ${gFile} found"
				newText=$(echo "$newText                        <text style=\"fill:#303030;stroke:none;fill-opacity:1\" transform=\"translate(20,$placeY)\">$carte$dNum</text>\n")
			else 
				echo "- First map in a raw"
			fi

			#Carte a droite
			if  [ -e $DIR/${dFile} ] ; then
				echo "- Right map ${dFile} found"
				x=$(echo $width - 20 | bc)
				#echo "<text style=\"fill:#303030;stroke:none;fill-opacity:1\" transform=\"translate($x,$placeY)\">$carte$gNum</text>\n"
			else 
				echo "- Last map in a raw"
			fi

			#Carte en haut
			if  [ -e $DIR/${hFile} ] ; then
				echo "- Up map ${hFile} found"
			else 
				echo "- Last line"
			fi
			
			#Carte en bas
			if  [ -e $DIR/${bFile} ] ; then
				echo "- Down map ${bFile} found"
			else 
				echo "- First line"
			fi
			
		done
	done
done

exit

carte=$1
uniterocarte=$(basename $1 .svg)


#cat $1 | sed s/"1 : 200,000"/"Carte "$uniterocarte/ > $carte.tmp


