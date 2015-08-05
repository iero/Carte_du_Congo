#!/bin/bash

file=$1

echo [ok] Clean file $file

width=$(cat $file | grep "<rect x=\"0\" y=\"0\"" | head -n 1 | \
	sed s#"<rect x=\"0\" y=\"0\""## | sed s#" height.*$"## | sed s#".*width=\""## | sed s/\"//)
height=$(cat $file | grep "<rect x=\"0\" y=\"0\"" | head -n 1 | \
	sed s#"<rect x=\"0\" y=\"0\""## | sed s#".*height=\""## |sed s/\".*//)

#echo "Map ${width}x${height}"

fline=$(sed -n /"<path style=\"fill:none\""/"{p;q;}" $file | sed s#"\" />.*$"#""# | sed s#"^.*<path style=\"fill:none\" d=\""##)

#echo "Line to replace : ($fline)"
for line in $(grep "<text style=\"fill:#303030;stroke:none;fill-opacity:1\"" $file | sed s#".*translate("## | sed s#").*"##) ; do
	latlong=$(echo $line | grep "^10," | sed s#"10,"#"M0 "# | sed s#"$"#" h $width"#)
	if [ ${#latlong} -eq  0 ] ; then
		latlong=$(echo $line | grep ",20$" | sed s#"^"#"M "# | sed s#",20"#" 0 v $height"#)
		#latlong=$(echo $line | grep ",20$" | sed s#"^"#"<path style=\"fill:none\" d=\"M "# | sed s#",20"#" 0 v $height\" "#)
	fi;
	#echo "By : ($latlong)"
	awk -v fline="$fline" -v latlong="$latlong" '$0 ~ fline && n == 0 { sub(fline,latlong); ++n } { print }' $file > $file.tmp
	mv $file.tmp $file
done

	#sed s///g | \
        export LANG=fr_FR.UTF-8
        DATE=$(date "+%B %Y")

cat $file | sed s#"Map Generated Using Maperitive (http://maperitive.net)"#"Congo map - iero.org"# | \
	sed s#"Map Generator: Maperitive v0.9.1228.24 by Igor Brejc"#"Copyright : S. et G. FABRE"# | \
	grep -v "^Time:" | \
	sed s#"Map data"#"$DATE"# | \
	sed s#"OpenStreetMap (and) contributors, CC-BY-SA"#"Severine et Greg FABRE - http://iero.org"# > $file.tmp
mv $file.tmp $file ;



