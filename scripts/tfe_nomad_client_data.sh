#!/usr/bin/env bash

#Change Hostname
sudo hostnamectl set-hostname "tfe-nomad-client"

export DEBIAN_FRONTEND=noninteractive

#Pre-reqs
apt-get update
apt-get install -y zip unzip wget apt-transport-https jq tree gnupg-agent net-tools

# DOCKER #
#Install docker
apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

#Add auto completion for docker
curl -fsSL https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
curl -fsSL https://github.com/docker/docker-ce/blob/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh

#Facilitate nomad access to docker
usermod -G docker -a ubuntu


# ENVOY #
curl -fsSL https://func-e.io/install.sh | bash -s -- -b /usr/local/bin
sudo cp `func-e which` /usr/local/bin


# ###CNI plug in
curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v0.9.1/cni-plugins-linux-$( [ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v0.9.1.tgz
mkdir -p /opt/cni/bin
tar -C /opt/cni/bin -xzf cni-plugins.tgz


#Install nomad manually
export NOMAD_SER_VERSION="1.8.2+ent"
curl --silent --remote-name https://releases.hashicorp.com/nomad/${NOMAD_SER_VERSION}/nomad_${NOMAD_SER_VERSION}_linux_amd64.zip
rm -rf TermsOfEvaluation.txt EULA.txt
unzip nomad_${NOMAD_SER_VERSION}_linux_amd64.zip
sudo chown root:root nomad
sudo mv nomad /usr/bin/


#Create directories
mkdir -p /opt/nomad
mkdir -p /etc/nomad.d

chmod 755 /opt/nomad
chmod 755 /etc/nomad.d


##Nomad Service File Configuration
cat <<EOF > /etc/systemd/system/nomad.service
[Unit]
Description=Nomad
Documentation=https://nomadproject.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStart=/usr/bin/nomad agent -config /etc/nomad.d/ -bind=0.0.0.0
KillMode=process
KillSignal=SIGINT
LimitNOFILE=infinity
LimitNPROC=infinity
Restart=on-failure
RestartSec=2
StartLimitBurst=3
StartLimitIntervalSec=10
TasksMax=infinity

[Install]
WantedBy=multi-user.target
EOF


#Nomad Configuration
cat <<EOF > /etc/nomad.d/client.hcl
log_level = "TRACE"

plugin_dir = "/opt/nomad/plugins"

data_dir  = "/opt/nomad/data"
bind_addr = "10.0.1.102"
name = "nomad-client"
client {
  enabled = true
  servers = ["10.0.1.101"]
  options = {
    "driver.raw_exec.enable" = "1"
  }
  cni_path = "/opt/cni/bin"
}
EOF


#Enable Nomad service
sudo systemctl enable nomad
sudo systemctl start nomad

sleep 15
