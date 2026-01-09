## Automate Data Capture at Scale with Document AI: Challenge Lab

### Run the following Commands in CloudShell
```
curl -LO https://raw.githubusercontent.com/Vallenzi/JuaraGCPS12/refs/heads/main/Automate%20Data%20Capture%20at%20Scale%20with%20Document%20AI%3A%20Challenge%20Lab/vallenz.sh
sudo chmod +x vallenz.sh
./vallenz.sh
````
### JIKA TASK 5 GAGAL

```

export PROJECT_ID=$(gcloud config get-value core/project)
gsutil -m cp -r gs://cloud-training/gsp367/* \
~/document-ai-challenge/invoices gs://${PROJECT_ID}-input-invoices/
```
### Congratulations !!!!

