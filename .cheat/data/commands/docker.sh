# Runn shell check on a bash script
docker run --rm -t -v "$PWD:/mnt" koalaman/shellcheck -e SC2039 <SCRIPT>
