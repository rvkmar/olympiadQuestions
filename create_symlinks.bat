@echo off
setlocal enabledelayedexpansion

rem Set the paths to the original files and folder
set "latexmkrc=C:\Users\Ravi\Desktop\olympiadQuestions\.latexmkrc"
set "credentials_json=C:\Users\Ravi\Desktop\olympiadQuestions\credentials.json"
set "google_sheet_questions=C:\Users\Ravi\Desktop\olympiadQuestions\GoogleSheetQuestions.py"
set "images_folder=C:\Users\Ravi\Desktop\olympiadQuestions\images"

rem Set the root directory
set "root_dir=C:\Users\Ravi\Desktop\olympiadQuestions"

rem Define folders to include
set "include_folders=Lochan Charan"

rem Iterate through all specified folders and their subdirectories
for %%d in (%include_folders%) do (
    for /d /r "%root_dir%" %%f in (%%d\*) do (
        rem Create symbolic links for specific files
        if not exist "%%f\.latexmkrc" mklink "%%f\.latexmkrc" "%latexmkrc%"
        if not exist "%%f\credentials.json" mklink "%%f\credentials.json" "%credentials_json%"
        if not exist "%%f\GoogleSheetQuestions.py" mklink "%%f\GoogleSheetQuestions.py" "%google_sheet_questions%"

        rem Create symbolic link for images folder
        if not exist "%%f\images" mklink /D "%%f\images" "%images_folder%"
    )
)

endlocal
