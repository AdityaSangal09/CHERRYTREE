# Path to your git repo
$repoPath = "C:\D FOLDER\CHERRYTREE"

# Change to repo directory
Set-Location $repoPath

# Create a filesystem watcher on the path for any changes
$fsw = New-Object System.IO.FileSystemWatcher $repoPath, "*.*"
$fsw.IncludeSubdirectories = $true
$fsw.EnableRaisingEvents = $true

# Define the action on change event
$action = {
    Write-Host "Detected changes. Syncing with GitHub..."
    # Add all changes (folder/file created, modified, deleted)
    git add .
    # Commit with a timestamp message
    git commit -m "Auto-sync commit on $(Get-Date -Format G)"
    # Push to origin main branch (adjust if using other branch)
    git push origin main
    Write-Host "Sync complete."
}

# Register change events: created, changed, deleted, renamed
Register-ObjectEvent $fsw Created -Action $action | Out-Null
Register-ObjectEvent $fsw Changed -Action $action | Out-Null
Register-ObjectEvent $fsw Deleted -Action $action | Out-Null
Register-ObjectEvent $fsw Renamed -Action $action | Out-Null

Write-Host "Watching for changes in $repoPath ..."
# Keep running
while ($true) { Start-Sleep -Seconds 10 }
