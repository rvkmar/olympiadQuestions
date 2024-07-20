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
    "https://scx2.b-cdn.net/gfx/news/hires/2011/workinglongh.jpg",
    "https://img.freepik.com/free-vector/hand-drawn-kidney-drawing-illustration_52683-160888.jpg?t=st=1721484525~exp=1721488125~hmac=9d0e033851cdf276a439cb7603a0e378743e3de93df3bf404298164f779b92fe&w=740",
    "https://img.freepik.com/free-vector/hand-drawn-liver-drawing-illustration_23-2151325544.jpg?w=740&t=st=1721483126~exp=1721483726~hmac=d345a2deff6610cc91b19222b5ca195c5ac8e3584751b64a5880ee73ae2de05e",
    "https://5.imimg.com/data5/GN/GY/EJ/SELLER-66931108/manual-blood-pressure-machine-500x500.jpg"
);

# Specify the filenames to save the images as
@image_filenames = ("01.jpg","02.jpg","03.jpg","04.jpg");

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
