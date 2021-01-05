# Create file: ~/.pypirc
[distutils]
index-servers =
  spvss-linear-video-deployer-pypi-local
[spvss-linear-video-deployer-pypi-local]
repository=https://artifactory01.engit.synamedia.com/artifactory/api/pypi/spvss-linear-video-deployer-pypi
username=linearvideodpl.gen
password=Pw-9HT_z#*

# Get tar.gz link of python package, e.g.:
# https://pypi.org/project/mkdocs-exclude-search/#files

# Wget it and extract it
wget <link>
tar xzvf <file>
cd <extracted_dir>

# Install required packages
sudo yum install python-wheel

# Upload it
python setup.py bdist_wheel upload -r spvss-linear-video-deployer-pypi-local

# Now you can use pip install in the deployer-base Dockerfile

