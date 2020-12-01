# Runn shell check on a bash script
docker run --rm -t -v "$PWD:/mnt" koalaman/shellcheck -e SC2039 <SCRIPT>

# Check which Docker overlay directory is created by which container (match /var/lib/docker/overlay2/<DIR_NAME> to a container)
docker inspect -f $'{{.Name}}\t{{.GraphDriver.Data.MergedDir}}' $(docker ps -aq)
