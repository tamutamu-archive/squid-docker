#!/bin/bash


pushd /tmp

apt-get -y install devscripts build-essential fakeroot cdbs debhelper dh-autoreconf

apt-get -y install \
    libsasl2-dev \
    libxml2-dev \
    libdb-dev \
    libkrb5-dev \
    nettle-dev \
    libnetfilter-conntrack-dev \
    libpam0g-dev \
    libldap2-dev \
    libcppunit-dev \
    libexpat1-dev \
    libcap2-dev \
    libltdl-dev \
    libssl-dev \
    libdbi-perl

wget http://www.squid-cache.org/Versions/v4/squid-4.8.tar.gz
tar xf squid-4.8.tar.gz
cd squid-4.8
./configure --prefix=/usr/local/squid --with-default-user=proxy --with-openssl --enable-ssl --enable-ssl-crtd
make
sudo make install

popd

cat << 'EOT' >> /etc/systemd/system/squid.service
[Unit]
Description=Squid caching proxy
After=syslog.target network.target nss-lookup.target

[Service]
Type=forking
LimitNOFILE=16384
EnvironmentFile=/usr/local/squid/etc/squid
ExecStart=/usr/local/squid/sbin/squid $SQUID_OPTS -f $SQUID_CONF
ExecReload=/usr/local/squid/sbin/squid $SQUID_OPTS -k reconfigure -f $SQUID_CONF
ExecStop=/usr/local/squid/sbin/squid -k shutdown -f $SQUID_CONF
TimeoutSec=0

[Install]
WantedBy=multi-user.target
EOT

cat << EOT >> /usr/local/squid/etc/squid
SQUID_CONF="/usr/local/squid/etc/squid.conf"
EOT

chown proxy:proxy /usr/local/squid -R

systemctl daemon-reload
systemctl enable squid


# Clean
shopt -s dotglob
rm -rf /tmp/*
apt clean
apt autoremove

