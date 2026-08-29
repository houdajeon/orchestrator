# install k3s
# 1. Create a bin directory inside your home folder if it doesn't exist
mkdir -p ~/.local/bin

# 2. Download the latest release binary for kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# 3. Make it executable and move it to your local bin directory
chmod +x kubectl
mv kubectl ~/.local/bin/
# Add to shell configuration
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

# Reload your shell configuration
source ~/.zshrc 2>/dev/null || source ~/.bashrc