# Generate an SSH key for deploying the VN-K8S cluster
ssh-keygen -t rsa -b 4096 -N "" -C "<COMMENT>" -f ~/.ssh/<KEYNAME>
