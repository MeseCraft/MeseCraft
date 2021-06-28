#!/bin/bash

# This program generates a bitmap font for font_api mod for Minetest game.
# (c) Andrzej Pieńkowski <pienkowski.andrzej@gmail.com>
# (c) Pierre-Yves Rollo <dev@pyrollo.com>
# License: GPL

usage() {
	echo "Usage: $0 fontfile fontname fontsize"
	echo "fontfile: A TTF font file to use to create textures."
	echo "fontname: The font name to be used in font_api (should be simple, with no spaces)."
	echo "fontsize: Font height to be rendered."
}

if [ $# -ne 3 ] 
then
	usage
	exit 1
fi

fontfile=$1
fontname=$2
fontsize=$3

if [ ! -r "$fontfile" ]
then
	echo "$fontfile not readable."
	exit 1
fi

# check imagemagick
hash convert &>/dev/null
if [ $? -eq 1 ]; then
	echo -e "Error: This program requires convert from ImageMagick! Please install it by typing 'sudo apt-get install imagemagick' in terminal."
	abort=1
fi

# check ttx
hash ttx &>/dev/null
if [ $? -eq 1 ]; then
	echo -e "Error: This program requires ttx from FontTools! Please install it by typing 'sudo apt-get install fonttools' in terminal."
	abort=1
fi

if [ $abort ]
then
	exit 1
fi

generate() {
	for i in $(seq $((0x$1)) $((0x$2)))
	do
		if echo "$codepoints" | grep -qi $(printf "0x%x" $i)
		then
		    hex=$(printf "%04x" $i)
		    echo -e "Generating textures/font_${fontname}_$hex.png file for \"\\U$hex\" char."
            if [[ "$hex" == "005c" ]] # Backslash char
            then
    			convert -background none -fill black -font "$fontfile" -pointsize $fontsize label:"\\\\" -colorspace gray -channel alpha -threshold 50% textures/font_${fontname}_$hex.png
            else
    			convert -background none -fill black -font "$fontfile" -pointsize $fontsize label:"$(echo -en "\\U$hex")" -colorspace gray -channel alpha -threshold 50% textures/font_${fontname}_$hex.png
            fi
 		fi
	done
}

mkdir textures

# Reads all available code points in the font.
codepoints=$(ttx -o - "$fontfile" | grep "<map code=" | cut -d \" -f 2)

# Mandatory chars
generate 0020 007f

# generate space and null characters
if [ ! -f "textures/font_${fontname}_0030.png" ]; then
	echo "Error: Something wrong happened! Font was not generated!"
	exit 1
else
	size=$(identify textures/font_${fontname}_0030.png | cut -d " " -f 3)
	if ! [[ $fontHeight =~ $re ]] ; then
		echo "Error: Something wrong happened! Generated files might be broken!"
		exit 1
	else
        w=$(expr $(echo $size | cut -d x -f 1) - 1)
        h=$(expr $(echo $size | cut -d x -f 2) - 1)
        # Space char
		convert -size $size xc:transparent -colorspace gray textures/font_${fontname}_0020.png
        # Null char		
        convert -size $size xc:transparent -colorspace gray -stroke black -fill transparent -strokewidth 1 -draw "rectangle 0,0 $w,$h" textures/font_${fontname}_0000.png
	fi
fi

# Optional Unicode pages (see https://en.wikipedia.org/wiki/Unicode) :

# 00a0-00ff Latin-1 Supplement (full)
generate 00a0 00ff
# 0100-017f Latin Extended-A (full)
generate 0100 017f
# 0370-03ff Greek (full)
generate 0370 03ff
# 0400-04ff Cyrilic (full)
generate 0400 04ff
# 2000-206f General Punctuation (Limited to Dashes)
generate 2010 2015
# 2000-206f General Punctuation (Limited to Quotes)
generate 2018 201F
# 20a0-20cf Currency Symbols (Limited to Euro symbol)
generate 20ac 20ac


