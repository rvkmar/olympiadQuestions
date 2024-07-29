use LWP::UserAgent;
use File::Spec;

# Path to the Conda environment's Python executable
$python_path = 'c:/Users/Ravi/Desktop/olympiadQuestions/.conda/python.exe';

# Path to the Python script
$script_path = 'C:\Users\Ravi\Desktop\olympiadQuestions\GoogleSheetQuestions.py';  # Update to the actual path of your script

# Run the Python script to generate the new .tex file
if (system("\"$python_path\" \"$script_path\"") != 0) {
    die "Error running GoogleSheetQuestions.py: $?";
}

# Specify the TeX engine
# Uncomment the engine you want to use. The default is set to pdflatex.

# For pdflatex
$pdf_mode = 1;
$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S';
$dvi_mode = 0;

# For xelatex
# $pdf_mode = 1;
# $xelatex = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';

# Specify the URLs of the images
@image_urls = (
    # "https://upload.wikimedia.org/wikipedia/commons/4/4f/Penitentes_Upper_Rio_Blanco_Argentine.jpg" # Penitentes, the ice cone rock
);

# Specify the filenames to save the images as
@image_filenames = (
    # "01.jpg" # Penitentes
);

# Specify the directory to save the images
my $image_dir = 'images';

# Ensure the image directory exists
mkdir $image_dir unless -d $image_dir;

# Custom subroutine to download images
sub download_images {
    # Skip download if no image URLs are provided
    if (scalar(@image_urls) == 0) {
        print "No image URLs provided. Skipping download.\n";
        return;
    }

    my $ua = LWP::UserAgent->new;
    for (my $i = 0; $i < scalar(@image_urls); $i++) {
        my $image_url = $image_urls[$i];
        my $image_file = File::Spec->catfile($image_dir, $image_filenames[$i]);

        # Check if the image already exists
        if (-e $image_file) {
            print "Image $image_file already exists. Skipping download.\n";
            next;
        }

        # Download the image if it does not exist
        print "Downloading image from $image_url\n";
        my $response = $ua->get($image_url, ':content_file' => $image_file);

        # Check if the download was successful
        if ($response->is_success) {
            print "Downloaded image successfully as $image_file.\n";
        } else {
            die "Failed to download image from $image_url: " . $response->status_line . "\n";
        }
    }
}


# Ensure images are downloaded before running LaTeX
download_images();

# Custom subroutine to delete the images after LaTeX processing
sub delete_images {
    my @files = glob(File::Spec->catfile($image_dir, '*'));
    for my $image_file (@files) {
        if (-e $image_file) {
            print "Deleting image $image_file\n";
            unlink $image_file or warn "Could not delete $image_file: $!\n";
        }
    }
}

# Custom subroutine to clean auxiliary files
sub clean_aux_files {
    my @aux_files = glob("*.{aux,log,nav,out,snm,toc,fls,fdb_latexmk,dvi}");

    for my $aux_file (@aux_files) {
        if (-e $aux_file) {
            print "Deleting auxiliary file $aux_file\n";
            unlink $aux_file or warn "Could not delete $aux_file: $!\n";
        }
    }
}

# Ensure the images and auxiliary files are deleted after LaTeX processing
END {
    if ($? == 0) {  # Check the exit status of the last command
        # delete_images();
        clean_aux_files();
        print "Tasks completed: PDF generated successfully.";
    } else {
        print "LaTeX processing failed with exit status $?.";
    }
}
