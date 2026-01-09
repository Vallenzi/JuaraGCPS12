#!/bin/bash

BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'

RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'
clear 


echo
echo "${BLUE_TEXT}${BOLD_TEXT}****************************${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}* WELLCOME TO VALLENZ TECH *${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}@@@@@@@@@@@@@@@@@@@@@@@@@@@@${RESET_FORMAT}"
echo

# Masukan ID
echo
echo "${BLUE_TEXT}${BOLD_TEXT}Masukan ID PROCESSOR:${RESET_FORMAT}"
read -r PROCESSOR_ID
export PROCESSOR_ID

# 1
echo
echo "${BLUE_TEXT}${BOLD_TEXT}1:${RESET_FORMAT} ${GREEN_TEXT}Updating sistem dan install dependencies.${RESET_FORMAT}"
sudo apt-get update
sudo apt-get install jq -y
sudo apt-get install python3-pip -y

# 2
echo
echo "${BLUE_TEXT}${BOLD_TEXT}2:${RESET_FORMAT} ${GREEN_TEXT}Buat service account Document AI and set up permissions.${RESET_FORMAT}"
export PROJECT_ID=$(gcloud config get-value core/project)
export SA_NAME="document-ai-service-account"
gcloud iam service-accounts create $SA_NAME --display-name $SA_NAME

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
--member="serviceAccount:$SA_NAME@${PROJECT_ID}.iam.gserviceaccount.com" \
--role="roles/documentai.apiUser"

gcloud iam service-accounts keys create key.json \
--iam-account  $SA_NAME@${PROJECT_ID}.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS="$PWD/key.json"

# 3
echo
echo "${BLUE_TEXT}${BOLD_TEXT}3:${RESET_FORMAT} ${GREEN_TEXT}Download PDF file for processing.${RESET_FORMAT}"
gsutil cp gs://cloud-training/gsp924/health-intake-form.pdf .

# 4
echo
echo "${BLUE_TEXT}${BOLD_TEXT}4:${RESET_FORMAT} ${GREEN_TEXT}Prepare JSON untuk Document AI API.${RESET_FORMAT}"
echo '{"inlineDocument": {"mimeType": "application/pdf","content": "' > temp.json
base64 health-intake-form.pdf >> temp.json
echo '"}}' >> temp.json
cat temp.json | tr -d \\n > request.json

# 5
echo
echo "${BLUE_TEXT}${BOLD_TEXT}5:${RESET_FORMAT} ${GREEN_TEXT}Send request Document AI API.Harap Sabar.${RESET_FORMAT}"
sleep 70
export LOCATION="us"
export PROJECT_ID=$(gcloud config get-value core/project)
curl -X POST \
-H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
-H "Content-Type: application/json; charset=utf-8" \
-d @request.json \
https://${LOCATION}-documentai.googleapis.com/v1beta3/projects/${PROJECT_ID}/locations/${LOCATION}/processors/${PROCESSOR_ID}:process > output.json

# 6
echo
echo "${BLUE_TEXT}${BOLD_TEXT}6:${RESET_FORMAT} ${GREEN_TEXT}output document yang telah di proses.${RESET_FORMAT}"
sleep 70
cat output.json | jq -r ".document.text"

# 7
echo
echo "${BLUE_TEXT}${BOLD_TEXT}7:${RESET_FORMAT} ${GREEN_TEXT}Download Python script untuk proses synchronous.${RESET_FORMAT}"
gsutil cp gs://cloud-training/gsp924/synchronous_doc_ai.py .

# 8
echo
echo "${BLUE_TEXT}${BOLD_TEXT}8:${RESET_FORMAT} ${GREEN_TEXT}Install Python dependencies.${RESET_FORMAT}"
python3 -m pip install --upgrade google-cloud-documentai google-cloud-storage prettytable

# 9
echo
echo "${BLUE_TEXT}${BOLD_TEXT}9:${RESET_FORMAT} ${GREEN_TEXT}Menjalankan script Python untuk proses synchronous.${RESET_FORMAT}"
export PROJECT_ID=$(gcloud config get-value core/project)
export GOOGLE_APPLICATION_CREDENTIALS="$PWD/key.json"

python3 synchronous_doc_ai.py \
--project_id=$PROJECT_ID \
--processor_id=$PROCESSOR_ID \
--location=us \
--file_name=health-intake-form.pdf | tee results.txt

# 10
echo
echo "${BLUE_TEXT}${BOLD_TEXT}10:${RESET_FORMAT} ${GREEN_TEXT}Send another request Document AI API untuk verifikasi.${RESET_FORMAT}"
export LOCATION="us"
export PROJECT_ID=$(gcloud config get-value core/project)
curl -X POST \
-H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
-H "Content-Type: application/json; charset=utf-8" \
-d @request.json \
https://${LOCATION}-documentai.googleapis.com/v1beta3/projects/${PROJECT_ID}/locations/${LOCATION}/processors/${PROCESSOR_ID}:process > output.json

# COMPLETE
echo
echo "${BLUE_TEXT}${BOLD_TEXT}${RESET_FORMAT}${MAGENTA_TEXT}${UNDERLINE_TEXT}IS DONE${RESET_FORMAT}"
echo
