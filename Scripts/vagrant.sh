# 1. Create a local bin folder if it doesn't exist
mkdir -p ~/.local/bin

# 2. Download the Vagrant zip package (v2.4.1)
curl -LO https://releases.hashicorp.com/vagrant/2.4.1/vagrant_2.4.1_linux_amd64.zip

# 3. Extract the zip archive
unzip vagrant_2.4.1_linux_amd64.zip

# 4. Move the executable to your local bin directory
mv vagrant ~/.local/bin/

# 5. Clean up zip file
rm vagrant_2.4.1_linux_amd64.zip