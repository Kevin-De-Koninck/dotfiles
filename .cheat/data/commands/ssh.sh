# Generate an SSH key for deploying the VN-K8S cluster
ssh-keygen -t rsa -b 4096 -N "" -C "<COMMENT>" -f ~/.ssh/<KEYNAME>

# Copy the SSH key to each of the cluster nodes (root and non-root)
ssh-copy-id -o IdentitiesOnly=yes -i ~/.ssh/mpdkey root@<IP>    # Use the root password
ssh-copy-id -o IdentitiesOnly=yes -i ~/.ssh/mpdkey mpduser@<IP> # Use the user password
