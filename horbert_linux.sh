#!/bin/bash

usage () {
	echo "Here is how to use $0:"
	echo "At first you can initialize a work folder where you will put your MP3's"
	echo "$0 --init <your_horbert_work_path>"
	echo "Once you are happy with the MP3's you set in this folder you can convert and copy those files"
	echo "to the Horbert SD card:"
	echo "Usage: $0 --input_folder <local_folder_with_mp3_path> --output_folder <SD_card_mount_point_path>"
	echo "Be carefull ! This will erase the content of your horbert SD card."
	exit 1
}

ARGUMENT_LIST=(
    "init:"
    "input_folder:"
    "output_folder:"
)

opts=$(getopt \
    --longoptions "$(printf "%s," "${ARGUMENT_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)

eval set --"$opts"

while [[ $# -gt 1 ]]; do
	case "$1" in
        --init)
		echo "init horbet local folder (where you can put your mp3 files)"
		exit 0
            ;;

        --input_folder)
		echo "Horbert input folder from where your MP3 files will be taken: $2"
		input_path="$2"
		shift
            ;;

        --output_folder)
		echo "Horbert output folder where WAV files will be copied to (possibly the SD card mount point) $2"
		output_path="$2"
		shift
            ;;

        *)
		usage
            ;;
    esac
    shift
done

exit 0
