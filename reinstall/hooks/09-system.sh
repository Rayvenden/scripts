#!/usr/bin/env bash

set -euo pipefail

ROOT_PASSWORD=$(get_cfg ".root_password")
echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}" | passwd
useradd -m -s /bin/bash -G sudo developer
mkdir /home/developer/.ssh
chmod 700 /home/developer/.ssh
mv "${FILES_DIR}/authorized_keys" /home/developer/.ssh/authorized_keys
chmod 600 /home/developer/.ssh/authorized_keys
chown -R developer:developer /home/developer
echo "developer ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer
chmod 440 /etc/sudoers.d/developer

truncate -s 0 /etc/machine-id || true
rm -rf /var/lib/dbus/machine-id || true
systemctl enable systemd-networkd
systemctl enable nftables

f=/etc/hosts
mv "${FILES_DIR}/hosts" "$f"
chmod 644 "$f"
chown root:root "$f"

f=/etc/systemd/network/80-dhcp.network
mv "${FILES_DIR}/80-dhcp.network" "$f"
chmod 644 "$f"
chown root:root "$f"

f=/etc/ssh/sshd_config
mv "${FILES_DIR}/sshd_config" "$f"
chmod 640 "$f"
chown root:root "$f"

f=/etc/resolv.conf
mv "${FILES_DIR}/resolv.conf" "$f"
chmod 644 "$f"
chown root:root "$f"

f=/etc/nftables.conf
mv "${FILES_DIR}/nftables.conf" "$f"
chmod 750 "$f"
chown root:root "$f"

f=/etc/fail2ban/jail.local
mv "${FILES_DIR}/jail.local" "$f"
chmod 640 "$f"
chown root:root "$f"

f=/etc/rc.local
mv "${FILES_DIR}/rc.local" "$f"
chmod 750 "$f"
chown root:root "$f"
