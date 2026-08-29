Vagrant.configure("2") do |config|

  # Master Node
  config.vm.define "master" do |master|
    master.vm.box = "debian/bookworm64"
    master.vm.hostname = "k3s-master"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.network "forwarded_port", guest: 3000, host: 3000

    master.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end

    master.vm.provision "shell", inline: <<-SHELL
      apt-get update && apt-get install -y curl
      curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.10 --write-kubeconfig-mode=644" sh -
      cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token
    SHELL
  end

  # Agent Node
  config.vm.define "agent1" do |agent|
    agent.vm.box = "debian/bookworm64"
    agent.vm.hostname = "k3s-agent1"
    agent.vm.network "private_network", ip: "192.168.56.11"

    agent.vm.provider "virtualbox" do |vb|
      vb.memory = "1536"
      vb.cpus = 1
    end

    agent.vm.provision "shell", inline: <<-SHELL
      apt-get update && apt-get install -y curl
      while [ ! -f /vagrant/node-token ]; do sleep 2; done
      TOKEN=$(cat /vagrant/node-token)
      curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.10:6443 K3S_TOKEN=$TOKEN INSTALL_K3S_EXEC="--node-ip=192.168.56.11" sh -
    SHELL
  end

end
