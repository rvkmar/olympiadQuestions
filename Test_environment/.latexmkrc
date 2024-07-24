# latexmkrc script to process questions and generate a new .tex file

# Run the Perl script to generate the new .tex file
if (system('perl process_questions.pl') != 0) {
    die "Error running process_questions.pl: $?";
}

# Set the name of the generated .tex file
$generated_tex = 'generated_document.tex';

# Compile the generated .tex file
$pdf_mode = 1;
$latex = 'pdflatex -interaction=nonstopmode';
$dvi_mode = 0;

# Set the root document to the generated .tex file
$root_doc = $generated_tex;

# Clean up intermediate files
END {
    if ($success) {
        print "PDF generated successfully.\n";
        system("latexmk -c $generated_tex");
    }
}
