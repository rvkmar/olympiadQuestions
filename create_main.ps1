# Define the source file and the target folders
$sourceFile = "C:\Users\Ravi\Desktop\olympiadQuestions\main.tex"
$folders = @("C:\Users\Ravi\Desktop\olympiadQuestions\Lochan", "C:\Users\Ravi\Desktop\olympiadQuestions\Charan")

foreach ($folder in $folders) {
    # Get all subdirectories in the current folder
    $subDirs = Get-ChildItem -Path $folder -Recurse -Directory

    foreach ($subDir in $subDirs) {
        # Define the destination path
        $destFile = Join-Path -Path $subDir.FullName -ChildPath "main.tex"

        # Check if the file already exists in the destination
        if (-Not (Test-Path -Path $destFile)) {
            # Copy the file to the destination path
            Copy-Item -Path $sourceFile -Destination $destFile -Force
            Write-Output "Copied to $destFile"
        } else {
            Write-Output "Skipped $destFile as it already exists."
        }
    }
}
