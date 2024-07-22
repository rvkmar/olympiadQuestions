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
    ## 01_Our_body_health
    # "https://scx2.b-cdn.net/gfx/news/hires/2011/workinglongh.jpg", #Heart
    # "https://img.freepik.com/free-vector/hand-drawn-kidney-drawing-illustration_52683-160888.jpg", #Kidney
    # "https://img.freepik.com/free-vector/hand-drawn-liver-drawing-illustration_23-2151325544.jpg", #Liver
    # "https://5.imimg.com/data5/GN/GY/EJ/SELLER-66931108/manual-blood-pressure-machine-500x500.jpg", #Sphygmomanometer - Blood pressure
    ## References:Human body 
    ## 02_plants_animals
    # "https://i.pinimg.com/736x/ef/bd/69/efbd694e48b145808ec415c380beb818.jpg", # Bat
    # "https://images.rawpixel.com/image_png_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvam9iNjcxLTE4Mi1wLWwxZGE5cTVqLnBuZw.png", # Frog
    # "https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA0L2pvYjcxNC0wMDUtcC5wbmc.png", # Monkey
    # "https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA0L2pvYjY3NC0xMzktdi5qcGc.jpg", # Cobra snake
    # "https://upload.wikimedia.org/wikipedia/commons/3/3a/Saru_Image.jpg", # papaya leaf
    # "https://upload.wikimedia.org/wikipedia/commons/4/42/Venus_Fly_Trap_%28Dionaea_muscipula%29_3.jpg" # venus fly trap carnivorous plant
    ## References
    ## 03_india_world

);

# Specify the filenames to save the images as
@image_filenames = (
    ## 01_Our_body_health
    "01.jpg",
    "02.jpg",
    "03.jpg",
    "04.jpg",
    ## References:Human body
    ## 02_plants_animals
    "05.jpg",
    "06.jpg",
    "07.jpg",
    "08.jpg",
    "09.jpg",
    "10.jpg",
    ## References
    ## 03_india_world
);

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
