#!/usr/bin/env bash

#Change Hostname
sudo hostnamectl set-hostname "tfe-nomad-server"

export DEBIAN_FRONTEND=noninteractive

#Pre-reqs
apt-get update
apt-get install -y zip unzip wget apt-transport-https jq tree gnupg-agent net-tools

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
cat <<EOF > /etc/nomad.d/server.hcl
log_level = "TRACE"

data_dir  = "/opt/nomad/data"
bind_addr = "10.0.1.101"
name = "nomad-server"
server {
  license_path = "/etc/nomad.d/license.hclic"
  enabled          = true
  bootstrap_expect = 1
}

#acl {
#  enabled = true
#}
EOF


#Writing License File
cat <<EOF > /etc/nomad.d/license.hclic
<Update_Your_Nomad_License_here>.  # For more please see the READEME file.
EOF

sudo systemctl enable nomad
sudo systemctl start nomad

sleep 15
