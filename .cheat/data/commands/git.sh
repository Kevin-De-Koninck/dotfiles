git checkout release/v2.2                                            # checkout develop branch
git pull --rebase && git submodule update --init --recursive         # Update develop branch
git checkout -b <feature/branch> release/v2.2                        # create local branch from develop
git push origin -u <feature/branch>                                  # Push local branch to remote (create on remote)

git push --force-with-lease                                          # Push with force when required (rebase)

git branch -d <branch>                                               # Delete branch locally
git push -d origin <feature/branch>                                  # Delete branch on remote

git config --global user.email "abc@def.com"                         # Config git email
git config --global user.name "Kevin De Koninck"                     # Config git username

git diff [--staged] [--unified=0]                 # show changes in files (unstaged, staged, with no context (only changes))
git diff BRANCH-1:path/file1 BRANCH-2:path/file2  # diff of files on different branches

git pull --rebase                                 # Pull and rebase new changes from remote
git fetch origin && git rebase                    # ^same as: git pull --rebase

git branch -a                                     # show all branches
git branch -d branchname                          # remove a local branch
git branch -D branchname                          # Force remove a local branch
git branch -vv                                    # show info of all branches
git branch -m newBranchName                       # rename

git checkout -b branchname                        # switch to branch
git checkout -                                    # Check out to previous branch
git checkout -b branchnameToCreate origin/v22-0   # create a local feature branch (you can push to the origin from this one)

git blame filename                                # show owner of each line
git log                                           # show log
git log --author=kdekonin                         # olny see commits of yourself
git log --stat                                    # see how many lines got deleted and added
git show --stat commitNumberHere                  # show changed files in a commit

git clean -fX                                     # remove non git-files
git remote -v                                     # show remote link
git cherry-pick commitHash                        # Cherry-pick a commit from a different branch
git cherry -v                                     # show local commits that are staged

git reset --hard HEAD~1                           # delete all local commits and changes on current branch
git reset HEAD~1                                  # remove last added local commit but keep changes in the files

git stash --include-untracked                     # place files in a stash so that you can change brnach
git stash pop                                     # pop your stash to continue your work

git rebase -i                                     # manage local commits (merge, rename, replace, delete, move)

git format-patch -1 <sha>                         # create patch
git am -3 < file.patch                            # apply the patch finally

