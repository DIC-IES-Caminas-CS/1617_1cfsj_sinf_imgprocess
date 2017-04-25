#!/bin/bash
=======
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
		load=`zenity --file-selection --directory --title="DAW Image Converter                              Load Images"`
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
                          echo "Saved"
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
        if [[ $ans =~ "Convert to format" ]]
        then
          format=`zenity  --list  --title "DAW Image converter" --text "Select the format that you want" \
          --radiolist --column "Pick" --column "Options" --width="500" --height="400" FALSE "png" FALSE "jpg" \
          FALSE "bmp" FALSE "tiff"`

        fi
        if [[ $ans =~ "Resize" ]]
        then
          zenity --entry --text="Desired dimensions ( px or % )" --entry-text "1024x768" --width=350 --height=150 --title "Images resize" --ok-label="Save changes" --cancel-label="Back"; echo $?
          case $sizeformat in
            0)
              zenity --question --title="Redimentions" --ok-label="Yes" --cancel-label="No" --text "Do you want to force redimention?"; echo $?
                case $? in
                  0)
                    echo "Yes"
                  ;;
                  1)
                    echo "No"
                  ;;
                esac
            ;;
            1)
            echo "Exit"
          ;;
          esac
        fi
#In then set the arguments you want to do
        if [[ $ans =~ "Rotate to the left" ]]
        then
          echo ""
        fi

        if [[ $ans =~ "Rotate to the right" ]]
        then
          echo ""
        fi

        if [[ $ans =~ "Invert" ]]
        then
          echo ""
        fi

        if [[ $ans =~ "Watermark" ]]
        then
          echo ""
        fi

        if [[ $ans =~ "Watermark" ]]
        then
          echo ""
        fi

        if [[ $ans =~ "Crop to size" ]]
        then
          echo ""
        fi

        if [[ $ans =~ "Delete" ]]
        then
          zenity --question --title="Delete" --text "Are you sure you want to delete the images?"; echo $?
          case $? in
            0)
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
=======
function comment () {
ls -1 $load*.* > .imagefiles.tmp

while read imgfile
do
	extract_name
	convert -comment "$comment" $imgfile.$format

done < .imagefiles.tmp
rm .imagefiles.tmp
}

function rotate () {
	ls -1 $load*.* > .imagefiles.tmp
>>>>>>> upstream/master


while read imgfile
do
	extract_name
	convert -comment "$comment" $imgfile.$format

<<<<<<< HEAD
done < .imagefiles.tmp
rm .imagefiles.tmp
=======
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
>>>>>>> upstream/master
}
>>>>>>> upstream/master
