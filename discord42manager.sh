#!/bin/bash

dirpath="$HOME/Downloads"

tarball_path="$dirpath/discord.tar.gz"

desktop_entry_dir="$HOME/.local/share/applications"

dl_url='https://discord.com/api/download?platform=linux&format=tar.gz'

function run_script() {
	if [[ "$1" == "install" ]]
	then
		install_discord
	elif [[ "$1" == "update" ]]
	then
		update_discord
	elif [[ "$1" == "uninstall" ]]
	then
		uninstall_discord
	else
		echo "unknown option '$1'"
		return 1
	fi
}

function dl_and_install() {
	echo -n "Downloading Discord to $tarball_path ... "
	wget -q "$dl_url" --output-document="$tarball_path" \
	&& echo "done." \
	&& echo -n "Extracting $tarball_path ... " \
	&& tar --directory="$dirpath" -xf "$tarball_path" \
	&& echo "done." \
	&& rm -v "$tarball_path" \
	&& echo "$dirpath/Discord" > .tmp \
	&& slashed=$(sed -e "s/\//\\\\\//g" .tmp) \
	&& rm .tmp \
	&& sed -e "s/\/usr\/share\/discord/$slashed/g" "$dirpath/Discord/discord.desktop" > "$desktop_entry_dir/discord.desktop" \
	&& return 0
	return 1
}

function install_discord() {
	if [[ ! -d "$dirpath/Discord" ]]
	then
		dl_and_install \
		&& echo "Discord should now be installed to $dirpath/Discord." \
		&& return 0
	else
		echo "Discord seems to be already installed."
		return 1
	fi
}

function remove_files() {
	rm -rf "$dirpath/Discord" \
	&& rm "$desktop_entry_dir/discord.desktop" \
	&& return 0
	return 1
}

function uninstall_discord() {
	if [[ -d "$dirpath/Discord" ]]
	then
		echo -n "Removing Discord files... " \
		&& remove_files \
		&& echo "done." \
		&& return 0
		return 1
	else
		echo "Discord does not seem to be installed."
		return 1
	fi
}

function update_discord() {
	if [[ -d "$dirpath/Discord" ]]
	then
		echo "Updating is just uninstalling/reinstalling."
		echo -n "Removing Discord files... " \
		&& remove_files \
		&& echo "done." \
		&& dl_and_install \
		&& echo "Discord should now be updated." \
		&& return 0
	else
		echo "Discord does not seem to be installed."
		return 1
	fi
}


if [[ "$1" == "" ]]
then
	echo "[0m       [31mX[37m                                     │"
	echo "[1;32m      [0;31m/<\[37m                                    │ Discord 42 Manager"
	echo "[1;32m     [0;31m/\ \\[32m_____________[37m                       │"
	echo "[1;32m    [0;31m/  ><[32m//_-_-_-_\  /!\[37m                     │ A script to install and update Discord"
	echo "[1;32m   [0;31m/\/\\ [32m/\X_______>\_\_/[37m    [35m▄▄▄▄▄▄▄▄▄[37m        │ on 42's linux dump"
	echo "  [31m/\  <[32m/\/<_/[31m\  _[32m/\_ \/[1;30m  [0;35m▄█████████████▄[37m     │ without waiting for the staff to update it"
	echo "[1;30m [0;31m/> Y\[32m<____/[1;31m  [0;31m\/[32m/\_ \/[1;30m [0;35m▄█████████████████▄[37m   │"
	echo "[31m/ \_! X___[1m [0;31m\/\ [32m/\_ \/[1;30m [0;35m▄████[1;37;45m▄▄▄▄   ▄▄▄▄[0;35m████▄[37m  │ The 'Discord' directory will be installed in '$dirpath'"
	echo "[31m\________/   /[32m/\_ \/[1;30m [0;35m▄████[1;37;45m▐███▄▄▄▄▄███▌[0;35m████▄[37m │ You can change the 'dirpath' in the script"
	echo "[1;30m        [0;31m/ <\/[32m/\_ \/[1;30m  [0;35m████[1;37;45m▐█████████████▌[0;35m████[37m │ The '$HOME/.local/share/applications/discord.desktop' file will be created"
	echo "       [31m/\ /[37m [32m/\_ \/[1;30m   [0;35m███[1;37;45m ████  ███  ████[0;35m████[37m │ so the app launcher can recognise it"
	echo "      [31m//\X[1;32m [0;32m/\_ \/[1;30m    [0;35m████[1;37;45m███████████████ [0;35m███[37m │"
	echo "     [31m///\[1;32m [0;32m//\ \/[1;30m      [0;35m███[1;37;45m▀███▄▄   ▄▄███▀[0;35m███[37m  │ Usage:"
	echo -n "     [31m\\ _/[32m/\\  ><_____[1;30m   [0;35m███████████████████[37m   │"
	echo -e "$0 install\tto install Discord"
	echo -n "      [31m\ [32m/</\>\_/ \_/\[37m   [35m▀███████████████▀[37m    │"
	echo -e "$0 uninstall\tto uninstall Discord"
	echo -n "       [32mX_____________>[1;30m     [0;35m▀▀███████▀▀[37m       │"
	echo -e "$0 update\tuninstall Discord and install new version"
else
	run_script $1
fi


