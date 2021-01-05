find . -name "filename.sh"        # find a file in current dir
find -type d -name __pycache__ -exec rm -rf {} \;  # Remove all __pychache dirs

locate <filename>                 # very fast
updatedb                          # update database that locate uses
