grep -rIn "search"                                             # grep (recursive, skip binary files and print line numbers)
git grep "search"                                              # faster grep (only in a git repo)
rg -i "search"                                                 # A really fast grep - https://github.com/BurntSushi/ripgrep

grep -rl include | xargs sed -i 's/include/include_tasks/'     # Change a word in different dirs
