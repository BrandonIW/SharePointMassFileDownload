# Define variables
$siteUrl = "https://sd36.sharepoint.com/sites/eSIS/"
$inputFilePath = "D:\Evidence\FileLists\ESIS.txt" # Provide the path to your input file
$destinationRootFolder = "D:\Evidence" # Provide the root local path where you want to save the files
$errorLogFilePath = "D:\Script\ESIS-Errors.txt" # Provide the path for the error log file

# Read the list of files from the input file
$filesToDownload = Get-Content $inputFilePath

# Connect to SharePoint site
Connect-PnPOnline -Url $siteUrl -UseWebLogin

# Initialize error log file
New-Item -Path $errorLogFilePath -ItemType File -Force | Out-Null

# Download each file from the list
foreach ($filePath in $filesToDownload) {
try {
        $destinationPath = Join-Path $destinationRootFolder $filePath.TrimStart('/')
        $destinationFolder = Split-Path $destinationPath -Parent
        
        # Create the local directory if it doesn't exist
        if (-not (Test-Path $destinationFolder)) {
            New-Item -ItemType Directory -Path $destinationFolder | Out-Null
        }

        # Download the file
        Get-PnPFile -Url $filePath -Path $destinationFolder -FileName (Split-Path $filePath -Leaf) -AsFile
    } catch {
        # Handle the error and log it to the error log file
        $errorMessage = "Error downloading file '$filePath': $_"
        Add-Content -Path $errorLogFilePath -Value $errorMessage
    }
}

# Disconnect from SharePoint site
Disconnect-PnPOnline
