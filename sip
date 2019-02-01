#!/usr/bin/env bash
#
# siphon - lil GCP wrapper for fast and private file sharing
# dependencies: gcloud, gsutil, grep, sort, bash 4+

# gs://siphon
bucket=siphon

main() {
	echo "Bucket set to gs://$bucket"
	printf '> '
	while read opt; do
		case $opt in
			login)         echo "Opening browser..."; gcloud auth login ;;
			ls|list)       echo "Fetching list..."; get_file_list v ;;
			dl*|download*) download_file ;;
			up*|upload*)   upload_file ;;
			q|quit)        break ;;
			*)
				echo "Commands:"
				echo "    login"
				echo "    ls, list"
				echo "    dl, download"
				echo "    up, upload"
				echo "    q, quit"
			;;
		esac
		printf '> '
	done
}

get_file_list() {
	# get detailed list of files in the bucket, sort for latest first
	files=$(gsutil ls -l gs://"$bucket" | grep -v TOTAL | sort -r -b -k2)

	# lines to array
	readarray -t files <<< "$files"		

	# trim down to bucket urls, print if verbose arg is present
	for ((i=0;i<"${#files[@]}";i++)); do
		files[$i]="gs${files[$i]#*gs}"
		[[ "$1" == "v" ]] && printf '%-4s%s\n' "$i" "${files[$i]##gs://$bucket/}"
	done
}

download_file() {
	# get and sort file list if not already done so
	[[ -v files ]] || get_file_list

	# parse target index
	args=($opt)
	t="${args[1]}"

	# check if target index is in range. NaN or missing will pass as 0
	n="${#files[@]}"
	if (( t >= 0 && t < n )); then
		f="${files[$t]##gs://$bucket/}"
		echo "Downloading $f"

		# download the file
		gsutil cp "${files[$ti]}" "$f" 
	else
		echo "Index out of range"
	fi
}

upload_file() {
	#parse file name
	args=($opt)
	f="${args[1]}"

	[[ "$f" == "" ]] && echo "Requires a file name" && return

	# if file exists
	if [[ -f "$f" ]]; then
		echo "Uploading $f" 
		
		# upload the file
		gsutil cp "$f" "gs://$bucket"
	else
		echo "$f is not a file"
	fi
}

main
