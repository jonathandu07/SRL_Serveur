# 🎬 SRL_Serveur  
Serveur multimédia avec **Sonarr**, **Radarr**, **Lidarr**, **Jellyfin**, **qBittorrent** et **Jackett**.  
Hébergé sur un PC ASUS sous **Zorin OS 17.3**, avec montages réseau vers un NAS local.

---

## 🌐 Interfaces Web

| Service      | Lien d'accès                                | Port |
|--------------|---------------------------------------------|------|
| **Sonarr**   | http://192.168.10.138:8989                  | 8989 |
| **Radarr**   | http://192.168.10.138:7878                  | 7878 |
| **Lidarr**   | http://192.168.10.138:8686                  | 8686 |
| **Jellyfin** | http://192.168.10.138:8096                  | 8096 |
| **qBittorrent** | http://192.168.10.138:8080              | 8080 |
| **Jackett**  | http://192.168.10.138:9117                  | 9117 |

---

## 🔐 Connexion SSH à la machine Zorin OS (ASUS-YHWH)

### 📍 Adresse IP locale :
`192.168.10.138`

### ✅ Connexion SSH :
```bash
ssh jonathan@192.168.10.138
```

### 🧠 Mot de passe :
> **habituel** (à saisir lors de la connexion)

### 🔧 Privilèges administrateur :
```bash
sudo -i
```

---

## 📦 Dossiers utilisés

### 🎵 Partages montés depuis le NAS :
- `/mnt/jellyfin/Sonarr` → Séries TV
- `/mnt/jellyfin/Radarr` → Films
- `/mnt/jellyfin/Lidarr` → Musique
- `/mnt/jellyfin` → Téléchargements

### ⚙️ Configurations locales :
- `/home/jonathan/sonarr/config`
- `/home/jonathan/radarr/config`
- `/home/jonathan/lidarr/config`
- `/home/jonathan/jellyfin/config`
- `/home/jonathan/qbittorrent/config`
- `/home/jonathan/jackett/config`

---

## 🐳 Lancer / Arrêter les services Docker

### ▶️ Lancement :
```bash
cd ~/srl-server
docker compose up -d
```

### ⏹️ Arrêt :
```bash
docker compose down
```

---

## 🔄 Montage des dossiers partagés (NAS)

### Fichier de credentials :
```bash
/etc/smbcredentials
```
Contenu :
```
username=jonathan
password=habituel
```

### Commandes de montage :
```bash
sudo mount -t cifs //192.168.10.156/usbshare1/jellyfin/Sonarr /mnt/jellyfin/Sonarr -o credentials=/etc/smbcredentials,vers=2.1,rw,uid=1000,gid=1000
sudo mount -t cifs //192.168.10.156/usbshare1/jellyfin/Radarr /mnt/jellyfin/Radarr -o credentials=/etc/smbcredentials,vers=2.1,rw,uid=1000,gid=1000
sudo mount -t cifs //192.168.10.156/usbshare1/jellyfin/Lidarr /mnt/jellyfin/Lidarr -o credentials=/etc/smbcredentials,vers=2.1,rw,uid=1000,gid=1000
```

### Se connecter à Bitorrent :
```bash
docker logs qbittorrent 2>&1 | grep "WebUI administrator"
```

- **Mot de passe oublié Bitorrent :** `docker logs qbittorrent 2>&1 | grep -i "temporary password"`
---
> 💡 À automatiser dans `/etc/fstab` si nécessaire.

---

## 🧠 Notes supplémentaires

- Sonarr/Radarr/Lidarr doivent être liés à **qBittorrent** (`http://192.168.10.138:8080`) pour lancer les téléchargements.
- **Jackett** permet d’ajouter des indexeurs manuellement à Sonarr/Radarr.
- Jellyfin détecte automatiquement les fichiers une fois organisés dans `/data/tvshows`, `/data/movies`, `/data/music`.

---

## ✏️ À faire

- [ ] Ajouter un script de vérification (`check_services.sh`)
- [ ] Sécuriser Jellyfin/qBittorrent avec authentification
- [ ] Ajouter un reverse proxy avec HTTPS
