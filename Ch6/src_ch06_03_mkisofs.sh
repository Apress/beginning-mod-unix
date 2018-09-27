mkisofs -iso-level 4 \
-allow-lowercase -allow-multidot -relaxed-filenames \ # Leniency hacks
-J -R \ # Pull in the Rockridge (Unix) and Joliet (Microsoft) extensions
-o cdimage.iso \ # The image to be compiled
*.pdf images/ # The paths for the input data
