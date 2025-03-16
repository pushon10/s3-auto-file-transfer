# PowerShell script to automate AWS S3 bucket creation and file transfer

# Function to check if AWS CLI is installed
function Check-AWSCLI {
    if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
        Write-Host "AWS CLI is not installed. Installing..."
        
        # Download AWS CLI installer
        $installerPath = "$env:TEMP\AWSCLIV2.msi"
        Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -OutFile $installerPath

        # Install AWS CLI silently
        Start-Process msiexec.exe -ArgumentList "/i $installerPath /quiet /norestart" -Wait
        
        # Verify installation
        if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
            Write-Host "AWS CLI installation failed. Please install it manually." -ForegroundColor Red
            exit 1
        } else {
            Write-Host "AWS CLI installed successfully!" -ForegroundColor Green
        }
    } else {
        Write-Host "AWS CLI is already installed." -ForegroundColor Green
    }
}

# Function to configure AWS credentials (use an existing profile or set via environment variables)
function Configure-AWS {
    Write-Host "Checking AWS credentials..."
    
    # Check if AWS credentials exist
    if (-not (Test-Path "$env:USERPROFILE\.aws\credentials")) {
        Write-Host "AWS credentials not found. Please enter them below."

        $accessKey = Read-Host "Enter AWS Access Key ID"
        $secretKey = Read-Host "Enter AWS Secret Access Key" -AsSecureString
        $region = Read-Host "Enter AWS Region (e.g., us-east-1)"

        # Convert secure string to plain text
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secretKey)
        $plainSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        # Configure AWS CLI
        aws configure set aws_access_key_id $accessKey
        aws configure set aws_secret_access_key $plainSecret
        aws configure set region $region
        aws configure set output json

        Write-Host "AWS credentials configured successfully!" -ForegroundColor Green
    } else {
        Write-Host "AWS credentials already configured." -ForegroundColor Green
    }
}

# Function to create an S3 bucket with a unique name
function Create-S3Bucket {
    param (
        [string]$BucketPrefix
    )

    $bucketName = "$BucketPrefix-$(Get-Random)"
    Write-Host "Creating S3 bucket: $bucketName"

    $createResponse = aws s3 mb "s3://$bucketName" 2>&1

    if ($createResponse -match "make_bucket") {
        Write-Host "Bucket created successfully: $bucketName" -ForegroundColor Green
        return $bucketName
    } else {
        Write-Host "Failed to create bucket: $createResponse" -ForegroundColor Red
        exit 1
    }
}

# Function to upload files to S3
function Upload-FilesToS3 {
    param (
        [string]$BucketName
    )

    # Create sample files
    Set-Content -Path "file1.txt" -Value "Hello World"
    Set-Content -Path "file2.txt" -Value "AWS CLI S3 Demo"
    New-Item -Path "myfolder" -ItemType Directory -Force
    Set-Content -Path "myfolder/file3.txt" -Value "Inside Folder"

    # Upload files
    aws s3 cp "file1.txt" "s3://$BucketName/"
    aws s3 cp "file2.txt" "s3://$BucketName/"
    aws s3 cp "myfolder/" "s3://$BucketName/myfolder/" --recursive

    Write-Host "Files uploaded to $BucketName" -ForegroundColor Green
}

# Function to copy files from one bucket to another
function Copy-FilesBetweenBuckets {
    param (
        [string]$SourceBucket,
        [string]$DestinationBucket
    )

    aws s3 cp "s3://$SourceBucket/" "s3://$DestinationBucket/" --recursive
    Write-Host "Files copied from $SourceBucket to $DestinationBucket" -ForegroundColor Green
}

# Function to clean up S3 buckets (optional)
function Cleanup-S3 {
    param (
        [string]$BucketName
    )

    aws s3 rm "s3://$BucketName/" --recursive
    aws s3 rb "s3://$BucketName"
    Write-Host "Deleted bucket: $BucketName" -ForegroundColor Yellow
}

# MAIN EXECUTION
Check-AWSCLI
Configure-AWS

# Create two S3 buckets dynamically
$bucket1 = Create-S3Bucket -BucketPrefix "shayan-test-bucket"
$bucket2 = Create-S3Bucket -BucketPrefix "shayan-test-bucket"

# Upload files to the first bucket
Upload-FilesToS3 -BucketName $bucket1

# Copy files from the first bucket to the second bucket
Copy-FilesBetweenBuckets -SourceBucket $bucket1 -DestinationBucket $bucket2

# Optional: Clean up buckets
$cleanup = Read-Host "Do you want to delete the buckets? (yes/no)"
if ($cleanup -eq "yes") {
    Cleanup-S3 -BucketName $bucket1
    Cleanup-S3 -BucketName $bucket2
}

Write-Host "S3 Automation Script Completed!" -ForegroundColor Green



