#!/bin/bash

echo "🛠️ Installation SRL_Serveur (Sonarr, Radarr, Lidarr)..."

# 1. Dépendances
sudo apt update
sudo apt install -y docker.io docker-compose cifs-utils

# 2. Préparation des dossiers
sudo mkdir -p /mnt/nas/{Sonarr,Radarr,Lidarr}
mkdir -p "$HOME/srl-server"/{sonarr/config,radarr/config,lidarr/config}

# 3. Création fichier credentials SMB
echo "username=jonathan" | sudo tee /etc/smbcredentials > /dev/null
echo "password=J0n@thandu07beestation" | sudo tee -a /etc/smbcredentials > /dev/null
sudo chmod 600 /etc/smbcredentials

# 4. Montage CIFS (NAS = 192.168.10.156)
echo "🔗 Montage des partages réseau..."
sudo mount -t cifs //192.168.10.156/usbshare1/jellyfin/Sonarr /mnt/nas/Sonarr -o credentials=/etc/smbcredentials,uid=$(id -u),gid=$(id -g),iocharset=utf8
sudo mount -t cifs //192.168.10.156/usbshare1/jellyfin/Radarr /mnt/nas/Radarr -o credentials=/etc/smbcredentials,uid=$(id -u),gid=$(id -g),iocharset=utf8
sudo mount -t cifs //192.168.10.156/usbshare1/jellyfin/Lidarr /mnt/nas/Lidarr -o credentials=/etc/smbcredentials,uid=$(id -u),gid=$(id -g),iocharset=utf8

# 5. Création du fichier docker-compose.yml
cat > "$HOME/srl-server/docker-compose.yml" <<EOF
version: '3.3'

services:
  sonarr:
    image: lscr.io/linuxserver/sonarr
    container_name: sonarr
    environment:
      - PUID=$(id -u)
      - PGID=$(id -g)
      - TZ=Europe/Paris
    volumes:
      - ./sonarr/config:/config
      - /mnt/nas/Sonarr:/tv
      - /mnt/nas:/downloads
    ports:
      - 8989:8989
    restart: unless-stopped

  radarr:
    image: lscr.io/linuxserver/radarr
    container_name: radarr
    environment:
      - PUID=$(id -u)
      - PGID=$(id -g)
      - TZ=Europe/Paris
    volumes:
      - ./radarr/config:/config
      - /mnt/nas/Radarr:/movies
      - /mnt/nas:/downloads
    ports:
      - 7878:7878
    restart: unless-stopped

  lidarr:
    image: lscr.io/linuxserver/lidarr
    container_name: lidarr
    environment:
      - PUID=$(id -u)
      - PGID=$(id -g)
      - TZ=Europe/Paris
    volumes:
      - ./lidarr/config:/config
      - /mnt/nas/Lidarr:/music
      - /mnt/nas:/downloads
    ports:
      - 8686:8686
    restart: unless-stopped
EOF

# 6. Lancer les services
cd "$HOME/srl-server"
docker-compose up -d

echo "✅ SRL_Serveur lancé !"
echo "🌐 Accès Sonarr : http://$(hostname -I | awk '{print $1}'):8989"
echo "🌐 Accès Radarr : http://$(hostname -I | awk '{print $1}'):7878"
echo "🌐 Accès Lidarr : http://$(hostname -I | awk '{print $1}'):8686"
