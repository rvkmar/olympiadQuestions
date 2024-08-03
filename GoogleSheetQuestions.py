import gspread
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd

# Define the scope and initialize the credentials
scope = ["https://spreadsheets.google.com/feeds", "https://www.googleapis.com/auth/drive"]
creds = ServiceAccountCredentials.from_json_keyfile_name('credentials.json', scope)
client = gspread.authorize(creds)

# Open the Google Sheet using its title
sheet = client.open("questionBank").sheet1

# Get all the data from the sheet
data = sheet.get_all_records()

# Convert the data to a pandas DataFrame for easier manipulation
df = pd.DataFrame(data)

# Generate LaTeX code
latex_code = "\\begin{questions}\n"  # Start the questions environment

for index, row in df.iterrows():
    latex_code += "\n"
    latex_code += "\\question{" + row['question_stem'] + "}\n"
    
    # Include description if it exists and is not blank
    if 'description' in row and pd.notna(row['description']) and row['description'].strip() != "":
        latex_code += "\n" + row['description'] + "\n"
    
    latex_code += "\n"
    
    # Generate choices environment based on choice_environment
    choice_env = row['choice_environment']
    
    if choice_env == 'choices':
        latex_code += "\\begin{choices}\n"
    elif choice_env == 'oneparchoices':
        latex_code += "\\begin{oneparchoices}\n"
    elif choice_env == 'randomizechoices':
        latex_code += "\\begin{randomizechoices}\n"
    elif choice_env == 'randomizeoneparchoices':
        latex_code += "\\begin{randomizeoneparchoices}\n"
    else:
        raise ValueError(f"Unknown choice environment: {choice_env}")
    
    latex_code += "\\CorrectChoice{" + row['CorrectChoice'] + "}\n"
    latex_code += "\\choice{" + row['Choice2'] + "}\n"
    latex_code += "\\choice{" + row['Choice3'] + "}\n"
    latex_code += "\\choice{" + row['Choice4'] + "}\n"
    
    latex_code += "\\end{" + choice_env + "}\n"

latex_code += "\n\\end{questions}\n\n"  # End the questions environment

# Save the LaTeX code to a file
with open("questions.tex", "w") as file:
    file.write(latex_code)

print("LaTeX code generated successfully!")
