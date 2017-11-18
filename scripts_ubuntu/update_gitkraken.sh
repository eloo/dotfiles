#!/bin/sh
# Based https://gist.github.com/grenade/3b3c5b17586881d01142

cd /tmp/

URL="https://release.gitkraken.com/linux/gitkraken-amd64.tar.gz"
FILE=${URL##*/}

wget -c "$URL" -O "$FILE"

if [[ ! -f "$FILE" ]]; then
	exit 1
fi

tar -xzf "$FILE" -C "/opt/"

ln -sf "/opt/gitkraken/gitkraken" "/usr/bin/gitkraken"

# cp "$(dirname $0)/gitkraken.svg" "~/.local/share/icons/hicolor/scalable/apps/"
gtk-update-icon-cache 
# -f -t ~/.local/share/icons/hicolor

cat <<EOF | tee ~/.local/share/applications/gitkraken.desktop
[Desktop Entry]
Name=GitKraken
Type=Application
Icon=gitkraken
Exec=gitkraken
Comment=The downright luxurious Git client
Categories=Development;IDE;
Keywords=Git;
StartupNotify=true
Terminal=false
EOF