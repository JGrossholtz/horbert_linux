# Horbert music manager for Linux
A music management and conversion script for the Linux users of the Horbert radio

![The Horbert Radio](https://static.hoerbert.info/wp-content/uploads/sites/5/2018/10/hoerbert_strand_titel.jpg)

The Horbert Radio is a radio designed for kids. They can turn it ON and select the music they want to listen to. The music stored internally can be managed from a PC on Microsoft Windows and OSX.

This project is a simple bash script allowing parents to manage the music from Linux PC on the Horbert ! It must be used from the console, but is designed to be as simple as possible to use.

## Installation
Open a terminal and run the following command:

```
sudo wget -O /usr/bin/horbert_linux https://raw.githubusercontent.com/JGrossholtz/horbert_linux/master/horbert_linux.sh && sudo chmod +x /usr/bin/horbert_linux
```

Alternatively, you can clone this repository and directly run the script.

## How to use
### First use: init
First, you must create your work directory:

```
horbert_linux --init $HOME
```

This creates a new folder called "horbert_workdir" in your main user directory. Feel free to replace $HOME by any other directory you have access to.

### Put your MP3's
Open a file browser and go in the horbert_workdir. You will find 9 directories:
```
.
├── 1_PURPLE
├── 2_RED
├── 3_DARK_BLUE
├── 4_LIGHT_GREEN
├── 5_YELLOW
├── 6_LIGHT_BLUE
├── 7_BLUE
├── 8_ORANGE
└── 9_GREEN
```

There is one directory for each of the 9 buttons on the Horbert. Now copy your MP3 files (MP3 only for now) to theses directories. Please ensure there are no sub-directories, they will be ignored.

### Convert and copy your music to the SD card

Insert your SD card to your PC. Find its absolute path, likely something similar to /run/media/your_username/HOERBERTINT.

Ensure you have a backup of the content of the music currently available on the SD card or it will be lost, then start the conversion:
```
horbert_kid_radio_converter --input_folder $HOME/horbert_workdir --output_folder /scard_mount_point/
```

This will start the conversion and files copy to the SD card. It may take a while. Once finished, eject properly the SD card from you PC and let your kids enjoy the music!

The next time you want to update the music on the radio, simply update the content of your horbert_workdir and run this step again.

## What is comming next
I plan to add the following features:
* Support flac files
* Support subfolders in the horbert_workdir
* Add a progress bar
* Ensure there is enough space left in the SD card before copy
* Handle existing .WAV files in the horbert_workdir
* Add an option to format the SD card
* Auto detect and mount the SD card

Please comment the existing issues to let me know what is important to you or open a new one if you want any other feature.

## Who am I ?
I am an [embedded software engineer](https://openest.io) with two amazing daughters. I am doing this project on my free time. Please give a Star to this project if you like it!

## Disclamer
I am not affiliated with Horbert or the Hoerbert company. I just needed an efficient tool to manage my daughter's radio. The Horbert Kid radio is available here: https://www.hoerbert.com/
