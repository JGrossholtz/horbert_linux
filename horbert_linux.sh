#!/bin/bash

WORKDIR="horbert_workdir"
TMP_DIRNAME=".tmp"

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

HORBERT_FOLDERS_LIST=(
    "1_PURPLE"
    "2_RED"
    "3_DARK_BLUE"
    "4_LIGHT_GREEN"
    "5_YELLOW"
    "6_LIGHT_BLUE"
    "7_BLUE"
    "8_ORANGE"
    "9_GREEN"
)

init_horbert_folder () {
	workpath="$1/$WORKDIR"

	mkdir -p "$workpath"
	for folder in "${HORBERT_FOLDERS_LIST[@]}"; do
		mkdir -p "$workpath/$folder"
	done

	echo "We just created the Horbert: $workpath"
	echo "You can place your mp3 files there and use this script later for automated conversion and copy"
}

convert_all_mp3_to_wav_in_directory () {
	convert_dir="$1"
	tmpdir="$convert_dir/$TMP_DIRNAME"

	if [ ! -d "$convert_dir" ] ; then
		echo "$convert_dir is not a valid directory"
		exit 4
	fi

	if [ -d "$tmpdir" ] ; then
		rm -rf "$tmpdir"
	fi

	mkdir -p "$tmpdir"

	file_no=0
	for file in "$convert_dir"/*.mp3 ; do
		echo ----- "$file"
		ffmpeg -i "$file" -acodec pcm_s16le -ac 1 -ar 32000 "$tmpdir"/"$file_no".WAV 2> /dev/null
		file_no=$((file_no+1))
	done

}

convert_mp3_to_horbert () {
	if [ -z "$input_path" ] && [ -z "$output_path" ] ; then
		echo ERROR: one directory variable is not set
		exit 1
	fi

	if [ ! -d "$input_path" ] ; then
		echo "$input_path is not a valid directory"
		exit 2
	fi

	if [ ! -d "$output_path" ] ; then
		echo "$output_path is not a valid directory"
		exit 3
	fi


	output_folder_no=0
	for dir in "${HORBERT_FOLDERS_LIST[@]}"; do
		if [ -d "$input_path"/"$dir" ]; then
			convert_all_mp3_to_wav_in_directory "$input_path"/"$dir"

			if [ -d "$output_path"/"$output_folder_no" ]; then
				rm -f "$output_path"/"$output_folder_no"/*
			else
				mkdir -p "$output_path"/"$output_folder_no"
			fi

			cp -f "$input_path"/"$dir"/"$TMP_DIRNAME"/* "$output_path"/"$output_folder_no"
		fi

		output_folder_no=$((output_folder_no+1))
		sync
	done

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
		init_horbert_folder "$2"
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

convert_mp3_to_horbert "$input_path" "$output_path"

echo "Your MP3 copy is finished ! Please disconnect your SD card properly"

exit 0
