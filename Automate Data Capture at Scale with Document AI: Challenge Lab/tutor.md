## Automate Data Capture at Scale with Document AI: Challenge Lab

### Run the following Commands in CloudShell
```
curl -LO https://raw.githubusercontent.com/Itsabhishek7py/GoogleCloudSkillsboost/refs/heads/main/Automate%20Data%20Capture%20at%20Scale%20with%20Document%20AI%20Challenge%20Lab/abhishek.sh
sudo chmod +x abhishek.sh
./abhishek.sh
````
### JIKA TASK 5 GAGAL

```

export PROJECT_ID=$(gcloud config get-value core/project)
gsutil -m cp -r gs://cloud-training/gsp367/* \
~/document-ai-challenge/invoices gs://${PROJECT_ID}-input-invoices/
```
### Congratulations !!!!

