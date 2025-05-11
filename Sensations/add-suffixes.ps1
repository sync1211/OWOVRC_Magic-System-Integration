$folders = Get-ChildItem . -Directory

Write-Host ">Adding suffixes..."
foreach ($folder in $folders) {
    $folderName = $folder.Name
    
    Write-Host "  $folderName..." -NoNewLine
    if ($folderName -eq "Base Elements") {
        Write-Host "Skipped" -ForegroundColor Yellow
        continue
    }

    cd $folder
    $files = Get-ChildItem $folder.FullName
    Write-Host "$($files.Length) Files" -ForegroundColor Green

    foreach ($file in $files) {
        Write-Host "    $($file.Name) -> " -NoNewLine
        $fileName = $file.Name.split(".")[0] # File name without extension
        $fileNameNew = $fileName + "_" + $folderName + ".owo"
        Write-Host  $fileNameNew

        Rename-Item $file $fileNameNew
    }
    cd ..
}