#!/bin/bash

# define colors
ESC_SEQ="\x1b["
COL_RED=$ESC_SEQ"31;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_RESET=$ESC_SEQ"39;49;00m"

echo -e $COL_BLUE"Let's update GitLab, ..."$COL_RESET


# Find the download URL
downloadUrl=$(curl -s https://about.gitlab.com/downloads/ | grep "wget" | grep "ubuntu-14.04" | sed -e 's/^ *//' -e 's/ *$//' | sed -e 's/<pre\>.*wget //')
if [ $? -eq 0 ]; then
	echo -e $COL_GREEN"Found download-URL: ${downloadUrl}"$COL_RESET
else
	echo -e $COL_RED"Download URL could not be detected!"$COL_RESET
	exit 1
fi


# Extract the version number out of the downloadable file's filename
fileName=$( echo "${downloadUrl}" | awk -F\/ '{print $(NF)}' )
downloadableVersion=$( echo "${fileName}" | cut -d\_ -f2 )
if [ $? -eq 0 ]; then
	echo -e $COL_GREEN"Downloadable version is: ${downloadableVersion}"$COL_RESET
else
	echo -e $COL_RED"Could not extract the version number from downloadable file name."$COL_RESET
	exit 2
fi


# Check which version is installed locally.
installedVersion=$( dpkg -s gitlab|grep Version|cut -d\: -f2|sed 's/\ //g' )
if [ $? -eq 0 ]; then
	echo -e $COL_GREEN"Currently installed version is: ${installedVersion}"$COL_RESET
else
	echo -e $COL_RED"Could not find out, which version is currently installed..."$COL_RESET
	exit 3
fi


# Check if we need to update at all...
if [[ "${installedVersion}" == "${downloadableVersion}" ]] ; then
	echo -e $COL_GREEN"We're allready running the current version, no update needed."$COL_RESET
	exit 4
else
	echo -e $COL_GREEN"There's a newer version available, let's install it..."$COL_RESET
fi


# Download the file
wget ${downloadUrl}


# Stop Unicorn Service
gitlab-ctl stop unicorn

# Stop Sidekiq
gitlab-ctl stop sidekiq

# If you are upgrading from 7.3.0
sudo gitlab-ctl stop nginx

# Create a backup
gitlab-rake gitlab:backup:create


# Install the new version
dpkg -i ${fileName}

# Re-Configure GitLab
gitlab-ctl reconfigure

# Restart Services
gitlab-ctl restart

# Remove downloaded .deb file
rm ${fileName}
