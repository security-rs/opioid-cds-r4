#!/bin/bash
#DO NOT EDIT WITH WINDOWS
#exit 1

v=3.8.0
dlurl='https://repo1.maven.org/maven2/org/opencds/cqf/tooling-cli/'${v}'/tooling-cli-'${v}'.jar'

echo ${dlurl}

input_cache_path=./input-cache/
tooling_jar='tooling-cli-'${v}'.jar'

set -e
if ! type "curl" > /dev/null; then
	echo "ERROR: Script needs curl to download latest IG Tooling. Please install curl."
	exit 1
fi

tooling="$input_cache_path$tooling_jar"
if test -f "$tooling"; then
	echo "IG Tooling FOUND in input-cache"
	jarlocation="$tooling"
	jarlocationname="Input Cache"
	upgrade=true
else
	tooling="../$tooling_jar"
	upgrade=true
	if test -f "$tooling"; then
		echo "IG Tooling FOUND in parent folder"
		jarlocation="$tooling"
		jarlocationname="Parent Folder"
		upgrade=true
	else
		echo IG Tooling NOT FOUND in input-cache or parent folder...
		jarlocation="$input_cache_path$tooling_jar"
		jarlocationname="Input Cache"
		upgrade=false
	fi
fi

if $upgrade ; then
	message="Overwrite $jarlocation? [Y/N] "
else
	#echo Will place tooling jar here: $input_cache_path$tooling_jar
	echo Will place tooling jar here: $jarlocation
	message="Ok? [Y/N]"
fi

read -r -p "$message" response
if [[ "$response" =~ ^([yY])$ ]]; then
	echo "Downloading most recent tooling to $jarlocationname - it's ~170 MB, so this may take a bit"
	curl $dlurl -L -o "$jarlocation" --create-dirs
	echo "Download complete."
else
	echo cancel...
fi
