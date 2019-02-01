# siphon (easy private file sharing)

Little wrapper to share files using a Google Cloud Platform bucket.

## Install and Run
- Download `sip`
- `chmod +x sip`
- `./sip` or add it to your bash path

## Setup
- Create a bucket on GCP
- Add members to the bucket's permissions through the GCP console
- Edit the `bucket` name in the script

## Usage
- `login` to login to your GCP google account with access to the bucket
- `ls` to list files
- `dl` to download an indexed file, defaults to most recently uploaded
- `up` to upload a file
- `q` to quit

## Dependencies
- `bash 4.0+`
- `gcloud` and `gsutil` from Google's Cloud SDK

## Todo
- [ ] `del` option to delete from bucket
- [ ] Download and rename
- [ ] Get rid of option loop model for native tab completing and more freedom? 
