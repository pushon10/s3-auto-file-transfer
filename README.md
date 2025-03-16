# s3-auto-file-transfer
A PowerShell script that automates S3 bucket creation, file uploads, and transfers using AWS CLI.

---

# **s3-auto-file-transfer**  
This **PowerShell script** fully automates the process of **creating S3 buckets, uploading files, and transferring data** using the AWS CLI—saving you time and effort.

With just **one command**, you can spin up two S3 buckets, upload files, transfer them, and optionally clean up all resources.

---

## **Features**
✅ **One-command execution** – Automates the full process  
✅ **Ensures AWS CLI is installed** – No manual setup required  
✅ **Uploads & transfers files** – No need to manage files manually  
✅ **Built-in clean-up option** – Keeps your AWS environment tidy  

---

## **Prerequisites**
- You must have an **AWS account** with permissions to manage S3.  
- AWS CLI should be configured with valid **access keys** (the script will prompt if missing).  
- **PowerShell** must be installed (available by default on Windows).  

---

## **Instructions**
1️⃣ **Navigate to your scripts directory** (optional but recommended):  
```powershell
cd C:\Users\User\Documents\Powershell_Automation_Scripts in my case.
```

2️⃣ **Clone this repository**:  
```powershell
git clone https://github.com/pushon10/s3-auto-file-transfer.git
```

3️⃣ **Navigate into the cloned repo**:  
```powershell
cd s3-auto-file-transfer
```

4️⃣ **Run the script**:  
```powershell
.\automate_s3_bucket_file_transfer.ps1
```

---

## **What This Script Does**
✅ **Checks for AWS CLI** and installs it if missing  
✅ **Configures AWS credentials** (if not already set)  
✅ **Creates two uniquely named S3 buckets**  
✅ **Uploads sample files to the first bucket**  
✅ **Copies all files from the first bucket to the second**  
✅ **Prompts the user to delete all resources (optional)**  

---

## **Use Cases & Customisation**
This script is designed for automating S3 bucket management and file transfers, but it can be easily modified to:

Transfer files between existing S3 buckets by replacing the Create-S3Bucket function with user-provided bucket names.
Sync files instead of copying, ensuring only new/updated files are transferred.
Schedule automatic backups using Windows Task Scheduler or a cron job.
Integrate with other AWS services (e.g., trigger an AWS Lambda function after file transfers).


## **Cleanup (Optional)**
To remove all created S3 resources after running the script, select **"yes"** when prompted.  
Alternatively, you can manually delete the buckets with:  
```powershell
aws s3 rm s3://your-bucket-name --recursive
aws s3 rb s3://your-bucket-name
```

---

This script is designed to **simplify S3 file transfers** while ensuring automation and efficiency. 
