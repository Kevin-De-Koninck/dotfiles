# If you are on werkbranch and you deleted a local commit (git reset --hard HEAD~1).
git reflog                    # get SHA1 number of the commit that you want to retrieve
git checkout SHA1             # retrieve that commit
git checkout -b test          # place that retrieved commit in a new branch (head will be in detached mode)
git branch -d werkBranch      # delete fucked up branch
git branch -m werkBranch      # rename test branch back to your original name
