# Create a new user
useradd mpduser

# Add a password for the user (mpduser)
echo mpdpassword | passwd mpduser --stdin

# Create the docker group
groupadd docker

# Add the new user to the required groups
usermod -aG wheel,docker mpduser
