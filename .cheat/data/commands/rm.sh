#Remove all files except 1 in a directory
shopt -s extglob ; rm -v !("myfile.txt")

