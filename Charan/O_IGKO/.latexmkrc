# latexmkrc file

use LWP::UserAgent;

# Specify the TeX engine
# Uncomment the engine you want to use. The default is set is VS code.

# For pdflatex
# $pdf_mode = 1;
# $pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S';

# For xelatex
# $pdf_mode = 1;
# $xelatex = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';

# Specify the URLs of the images
@image_urls = (
    "https://upload.wikimedia.org/wikipedia/commons/4/4f/Penitentes_Upper_Rio_Blanco_Argentine.jpg"
);

# Specify the filenames to save the images as
@image_filenames = ("01.jpg");

# Custom subroutine to download images
sub download_images {
    my $ua = LWP::UserAgent->new;
    for (my $i = 0; $i < scalar(@image_urls); $i++) {
        my $image_url = $image_urls[$i];
        my $image_file = $image_filenames[$i];

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
    for my $image_file (@image_filenames) {
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
    delete_images();
    clean_aux_files();
    print "Tasks successfully completed.";
}
