#!/bin/bash
# running under sudo from packer

cd /var/tmp
curl -O http://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-latest.tar.gz
tar xvzf ansible-tower-setup-latest.tar.gz
cd ansible-tower-setup-2*
cat > tower_setup_conf.yml<<'EOF'
admin_password: admin
database: internal
munin_password: admin
pg_password: QbN5e8ALJY5GQBdWntWXtxuLaUWJMXZybipE4RF3
primary_machine: localhost
redis_password: E8f2g7kpASzCi2S7t3PvPDHnzWnqNsbg3c6fcHZe
EOF

cat > inventory<<'EOF'
[primary]
localhost

[all:children]
primary
EOF

./setup.sh

