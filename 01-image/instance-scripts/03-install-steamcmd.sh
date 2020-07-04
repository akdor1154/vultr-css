#!/bin/sh

set -e
(
    cd /tmp
    wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
)

rm -rf /opt/steamcmd
mkdir /opt/steamcmd
chown steam:steam /opt/steamcmd
(
    cd /opt/steamcmd
    tar -xvf /tmp/steamcmd_linux.tar.gz
)

# install steam
sudo -u steam -H /bin/sh - << EOS1
    set -e
    cd /opt/steamcmd
    ./steamcmd.sh << 'EOSTEAM'
        @ShutdownOnFailedCommand 1
        @NoPromptForPassword 1
        quit
'EOSTEAM'
EOE

EOS1

# unusued for now. anonymous is fine.
# # preliminary login
# sudo -u steam -H --preserve-env=STEAM_PASSWORD /bin/sh - << EOS2
#     set -e
#     cd /opt/steamcmd
#     expect <<'EOE'
#         set timeout 300
#         spawn ./steamcmd.sh
#         expect "Steam>"
#         send "login ${STEAM_USER}\r"
#         expect {
#             "password:" {
#                 send "\$env(STEAM_PASSWORD)\r"
#                 exp_continue
#             }
#             "FAILED" {
#                 close
#                 exit 1
#             }
#             "Steam Guard code:" {
#                 close
#                 exit 1
#             }
#             "*Logged in OK" { }
#         }
#         expect "Steam>"
#         send "quit\r"
#         expect eof
# EOE

# EOS2

# install CSS
# preliminary login
rm -rf /opt/css
mkdir /opt/css
chown steam:steam /opt/css
sudo -u steam -H /bin/sh - << EOS2
    set -e
    cd /opt/steamcmd
    ./steamcmd.sh << 'EOSTEAM'
        @ShutdownOnFailedCommand 1
        @NoPromptForPassword 1
        login anonymous
        force_install_dir /opt/css
        app_update 232330 validate
        quit
EOSTEAM
EOS2

cat > /opt/css/updatescript << EOF
login anonymous
force_install_dir /opt/css
app_update 232330
quit
EOF
chown steam:steam /opt/css/updatescript

systemctl daemon-reload
systemctl enable css.service
