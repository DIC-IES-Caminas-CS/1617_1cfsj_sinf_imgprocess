#!/bin/bash

count=1
path=""
format=""

function add_comment () {
ls -1 $load/*.* > .imagefiles.tmp

while read imgfile
do
	extract_name
	convert -comment "$comment" $final_file

done < .imagefiles.tmp
rm .imagefiles.tmp
}

function delete () {
	rm $dir/*
}


function rotate () {
	ls -1 $load/*.* > .imagefiles.tmp

while read imgfile
do
	extract_name
	convert -rotate $valuerotate $imgfile $final_file
done < .imagefiles.tmp

rm .imagefiles.tmp
}

function resize-format () {
  #option=2
  #read -p "Force or not(0-1): " force  | Get from GUI
  #read -p "Input the size: " input  | Get from GUI
  ls -1 $load/*.* > .imagefiles.tmp
  while read imgfile
  do
  	extract_name
  		if [ $force -eq 0 ]; then
  			input+="!"
  			convert $imgfile -resize $input $final_file
  		else
  			convert $imgfile -resize $input $final_file
  		fi
  done < .imagefiles.tmp
  rm .imagefiles.tmp
}

#function to change load if there are more than one processing option.
#Use function overwrite_load in all options
function overwrite_load () {
  if [[ count -eq 1 ]]
  then
    load=$path
  fi
}
#function to define final_file (path)
function extract_name () {
  filename=$(basename "$imgfile") #Extract the name file ex: file.jpg
  namefile="${filename%.*}" #Extract name of a file without extension
  pathfile="$path/$namefile" #Put together path and name file, then we choose the extension to convert
	if [ $count = 1 ]
	then
		final_file="$imagefile"
	else
		final_file="$pathfile.$format"
	fi
		#statements
}

define_path #function


function watermark () {
  ls -1 $load/*.* > .imagefiles.tmp
  #format="png"  |  Get the format from the GUI.
  #read -p "Introduce the watermark text: " watermark  |  Get the watermark text form GUI
  while read imgfile
  do
    extract_name

    convert -size 140x80 xc:none -fill grey \
            -gravity NorthWest -pointsize 15 -draw "text 10,10 '$text'" \
            -gravity SouthEast -pointsize 15 -draw "text 5,15 '$text'" \
            miff:- |\
      composite -tile - $imgfile  $final_file
  done < .imagefiles.tmp
  rm .imagefiles.tmp

}
function format_change () {
	ls -1 $load/*.* > .imagefiles.tmp
	while read imgfile
	do
		extract_name
		convert $imgfile $pathfile.$format
	done < .imagefiles.tmp
	rm .imagefiles.tmp
}

function image-edit () {
	ls -1 $load/*.* > .imagefiles.tmp

	while read imgfile
	do
		extract_name

		convert $imgfile -auto-level $final_file


	done < .imagefiles.tmp
	rm .imagefiles.tmp
}

#INTERFACE CODE--------------
FILE=`dirname $0`/COPYING
#license
zenity --text-info \
       --title="License" \
       --filename=$FILE \
       --checkbox="I read and accept the terms."
#Show list
case $? in
    0)
        echo "Start installation!"		#load bar
		dir=`zenity --file-selection --directory --title="DAW Image Converter                              Load Images"`
		load=$dir
		case $? in
         	0)
                echo "\"$load\" selected."
#Options
				ans=$(zenity  --list  --title "DAW Image converter" --text "Select the option that you want" \
        --checklist --column "Pick" --column "Options" --width="500" --height="400" FALSE "Rotate to the right" \
         FALSE "Rotate to the left" FALSE "Invert" FALSE "Resize" FALSE "Watermark" \
         FALSE "Convert to format" FALSE "Crop to size" FALSE "Add comment" FALSE "Delete" FALSE "Automatic edit" --separator=":"); echo $ans

#Switch with if's for each option
        case $? in
             	0)
              #Dialog
                  zenity --question --width=350 --height=120 --title "SAVE" --ok-label="Save in other folder" \
                  --cancel-label="Overwrite" --text "Where do you want to save the news pictures?" ;
                  case $? in
                    0)
                      echo $?
                      path=`zenity --file-selection --directory --title="DAW Image Converter                              Save Images"`
                    ;;
                    1)
                      zenity --question --title="Overwrite" --text "Are you sure you want to overwrite the images?"; echo $?
                      case $? in
                        0)
                          path=$load
                          echo "Starting image processing"
                        ;;
                        1)
                          echo"Exit"
                        ;;
                      esac
                    ;;
                  esac
              ;;

              1)
              echo "Exit"
              ;;
        esac
#Begining processing options
        if [[ $ans =~ "Convert to format" ]]
        then
          count= $(($count+1))
          format=`zenity  --list  --title "DAW Image converter" --text "Select the format that you want" \
          --radiolist --column "Pick" --column "Options" --width="500" --height="400" FALSE "png" FALSE "jpg" \
          FALSE "bmp" FALSE "tiff"`; echo $format
					format_change
					overwrite_load
        fi
				if [[ $ans =~ "Rotate to the left" ]]
				then
					count=$(($count+1))
					valuerotate=-90
					rotate  #call function
					echo ""
					overwrite_load
				fi

				if [[ $ans =~ "Rotate to the right" ]]
				then
					count=$(($count+1))
					valuerotate=90
					rotate  #call function
					echo ""
					overwrite_load
				fi

				if [[ $ans =~ "Invert" ]]
				then
					count=$(($count+1))
					valuerotate=180
					rotate #call function
					overwrite_load
				fi

        if [[ $ans =~ "Resize" ]]
        then
          count=$count+1
          input=$(zenity --entry --text="Desired dimensions ( px or % )" --entry-text "1024x768" --width=350 --height=150 --title "Images resize" --ok-label="Save changes" --cancel-label="Back"); echo $?
          force=1
						if [[ $input =~ "x" ]]
						then
              zenity --question --title="Redimentions" --ok-label="Yes" --cancel-label="No" --text "Do you want to force redimention?"; echo $?
                case $? in
                  0)
									force=0
                    echo "Yes-Force"
                  ;;
                  1)
									force=1
                    echo "No- No force"
                  ;;
                esac
            fi
          resize-format #call function
					overwrite_load
        fi

        if [[ $ans =~ "Watermark" ]]
        then
          count=$(($count+1))
					text=$(zenity --entry --text="Desired watermark" --entry-text "Your watermark" --width=350 --height=150 --title "Images resize" --ok-label="Save changes" --cancel-label="Back"); echo $?
          watermark
          echo ""
					overwrite_load
        fi

        if [[ $ans =~ "Add comment" ]]
        then
					echo $load
          count=$(($count+1))
					comment=$(zenity --entry --text="Desired comment" --entry-text "Your comment" --width=350 --height=150 --title "Images resize" --ok-label="Save changes" --cancel-label="Back"); echo $?
					add_comment
          echo ""
					overwrite_load
					echo $load
        fi

				if [[ $ans =~ "Automatic edit" ]]
				then
					count=$(($count+1))
					image-edit
					echo ""
					overwrite_load
				fi

				if [[ $ans =~ "Crop to size" ]]
        then
          count=$(($count+1))
          echo ""
					overwrite_load
        fi

        if [[ $ans =~ "Delete" ]]
        then
          zenity --question --title="Delete" --text "Are you sure you want to delete the images?"; echo $?
          case $? in
            0)
							delete
              echo "Deleted"
            ;;
            1)
              echo "Exit"
            ;;
          esac
        fi

				if [ "$?" = -1 ] ; then
        			zenity --error \
        		  	--text="Update canceled."

				fi;;
         	1)
                echo "No file selected.";;
        	-1)
                echo "An unexpected error has occurred.";;
		esac
	;;
    1)
        echo "Stop installation!"
	;;
    -1)
        echo "An unexpected error has occurred."
	;;
esac
