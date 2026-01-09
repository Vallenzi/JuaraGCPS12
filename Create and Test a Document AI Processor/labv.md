## Create and Test a Document AI Processor

### Run the following Commands in CloudShell
```bash
gcloud services enable documentai.googleapis.com
export ZONE=$(gcloud compute instances list document-ai-dev --format 'csv[no-heading](zone)')
gcloud compute ssh document-ai-dev --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet
```

* Open **`Document AI`** from [HERE](https://console.cloud.google.com/ai/document-ai?)
* Processor Name: **`form-parser`**
* Download [form.pdf](https://storage.googleapis.com/cloud-training/document-ai/generic/form.pdf)



```
curl -LO https://raw.githubusercontent.com/Vallenzi/JuaraGCPS12/refs/heads/main/Create%20and%20Test%20a%20Document%20AI%20Processor/vallenz.sh
sudo chmod +x vallenz.sh
./vallenz.sh
```
### Congratulations !!!!

