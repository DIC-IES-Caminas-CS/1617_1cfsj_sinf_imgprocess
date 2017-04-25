#!/bin/bash
function rotate () {
	ls -1 $load*.* > .imagefiles.tmp

	while read imgfile
	do

		convert -rotate $valuerotate $imgfile $imgfile

	done < .imagefiles.tmp
	rm imagefiles.tmp
}

function resize-format () {
  #option=2
  #read -p "Force or not(0-1): " force  | Get from GUI
  #read -p "Input the size: " input  | Get from GUI
  #read -p "Input the format: " format  | Get from GUI
  ls -1 $load*.* > .imagefiles.tmp
  while read imgfile
  do
  	extract_name
  	case $option in
  		1)
  		convert $imgfile -resize $input $pathfile.$format
  		;;
  		2)
  		if [ $force = 0 ]; then
  			input+="!"
  			convert $imgfile -resize $input $pathfile.$format
  		else
  			convert $imgfile -resize $input $pathfile.$format
  		fi
  		;;
  	esac
  done < .imagefiles.tmp
  rm .imagefiles.tmp
}

#Add code to save in new folder
function define_path () {
  if [[ ! $path = "" ]]
  then
    path=$load
  fi
}
#function to change load if there are more than one processing option.
#Use function overwrite_load in all options
function overwrite_load () {
  if [[ counter = 1 ]]
  then
    load=$path
  fi
}
#function to define final_file (path)
function extract_name () {
  filename=$(basename "$imgfile") #Extract the name file ex: file.jpg
  namefile="${filename%.*}" #Extract name of a file without extension
  pathfile="$path/$namefile" #Put together path and name file, then we choose the extension to convert
}

counter=0

define_path #function


function watermark () {
  ls -1 $load*.* > .imagefiles.tmp
  #format="png"  |  Get the format from the GUI.
  #read -p "Introduce the watermark text: " watermark  |  Get the watermark text form GUI
  while read imgfile
  do
    extract_name

    convert -size 140x80 xc:none -fill grey \
            -gravity NorthWest -pointsize 15 -draw "text 10,10 '$watermark'" \
            -gravity SouthEast -pointsize 15 -draw "text 5,15 '$watermark'" \
            miff:- |\
      composite -tile - $imgfile  $pathfile.$format
  done < .imagefiles.tmp
  rm .imagefiles.tmp

}
function image-edit () {
	ls -1 $load*.* > .imagefiles.tmp
	format="png"

	while read imgfile
	do
		extract_name

		convert $imgfile -auto-level $pathfile.$format


	done < .imagefiles.tmp
	rm .imagefiles.tmp
}
