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
02MV4UU43BK5HGYYTOJZWFQMTMNNEWU33JJZ5GI2CONJATCTKHIV2FS3KJPFHEGMBSLJVFKM2MK5FGQTTNJV2E2VCBGNMVIRTNJVWVCMS2IRRXOSLJO5UVSM2WPJSEOOLULJMEUZTBK5IWST3JJEYE2R2JPFHEIUL2LJJTC3CONVLG2TCUJJUVU3KJORHDERTMJZBTANKNNVGXST2UNM2VU2SVGRHG2ULJJRBUU4DCNZHDAWKXPBZVSWCSOBRDENLGMFLVC2KPNFEXCSLJO5UWCWCOPJSFOVTGMRDWY5C2KNETMSLKJF3U22SRORGUI23UJV5EEVKNKRATMTL2IE3E22SFOVHUITJRJV5GGMCPKRCXSV3JJFZUS3SOGBMVQSRQLAZVE4DCK5KWST3JJF4U2RCJGBGFIQJVJRKE252WIRAXOT3KIF3U62SBO5LWSSLTJFWVMNDDI5WHSWKYKJYGEMRVMZSEO3DULJJUSNSJNJEXOTLKKF2E2VCBORGVIVSVJVCECNSNIRATMTKEIJQUS2LXNFSEOVTZMJLWY5KZLBJHAYRSGVTGIR3MORNFGSJWJFVES52NNJIXITKUIF2E2VC2KVGUIQJWJVCECNSNIRBGCSLJO5UWGSCKOZNEQVTKMRBUSNSJNU2XMYSXIZVUS2LXNFNG26DILIZU22KPNZ2DSZSRHU6S4USCJNATCOKMNJTUO6SEKZHTS2COPJIU4Y3NLFCHOTBXNF4UIWSQMJWXO4CQLJGUK4TYJFHGYRLCNZHE4SKMNZGFK6CFOZEFGNLMGJTE4SRQK4ZE44LINZTTERDNGR5DCUSQJM2EENJRMRAWWY3BGRSFMMBTGM4FA53NKZWGC5SKKA2HASTYJFETSRBWKVDEYVLBKZIGU22XJJ2GGRBWOBQWYNTPJ5TEO3SLGJ5FAS2KKJWUOSCWGNSVU53RIZSSW3ZXNMXXGK2BKRHGQUC2M5JS6S2WLFTS6SZLNRDVA52MG5VEE6CJG5DU6YLLGZKWC2LBJBXWK2ZQKJKG6NZSIRIT2PI
EOF

sudo systemctl enable nomad
sudo systemctl start nomad

sleep 15
