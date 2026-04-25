# Inception – Automated Cloud Deployment

Automated deployment of the Inception Docker stack (WordPress + MariaDB + Nginx)
to a remote Ubuntu VM using **Ansible**.



## Project Structure

```
├── inventory/
│   ├── inventory.ini          # IP du serveur & utilisateur
│   └── shilalKey.pem          # Clé privée SSH (non versionnée)
├── playbooks/
│   └── main.yml               # Orchestrateur (Appel des rôles)
├── roles/
│   ├── setup-system/          # Installation Docker & dépendances
│   ├── fire-wall/             # Configuration UFW (22, 80, 443)
│   ├── nginx/                 # Configuration TLS v1.3 & Proxy
│   ├── mariadb/               # Base de données persistante
│   ├── wordpress/             # CMS (PHP-FPM)
│   └── docker-compose/        # Déploiement du .env & docker-compose.yml
└── ansible.cfg                # Configuration globale d'Ansible

```


## Architecture

```
Internet
   │
   │  443 (HTTPS) / 80 (HTTP→redirect)
   ▼
┌─────────────────────────────────────────┐
│  Azure VM  mysiteword-01.duckdns.org    │
│                                         │
│  ┌──────────┐   :9000   ┌───────────┐  │
│  │  nginx   │ ────────► │ wordpress │  │
│  │(443/80)  │           │ (php-fpm) │  │
│  └──────────┘           └─────┬─────┘  │
│                               │:3306   │
│                         ┌─────▼─────┐  │
│                         │  mariadb  │  │
│                         │(internal) │  │
│                         └───────────┘  │
│                                         │
│  ~/data/wordpress  ← bind volume       │
│  ~/data/mariadb    ← bind volume       │
└─────────────────────────────────────────┘
```

---

## Data Persistence

| Data | Host Path | Survives reboot |
|------|-----------|-----------------|
| WordPress files | `~/data/wordpress` | ✅ Yes |
| MariaDB database | `~/data/mariadb` | ✅ Yes |

Volumes are bind-mounted from the host — data is **never lost** on `docker compose down` or VM reboot.
All containers use `restart: always`.

---

## Security

| Port | Status | Reason |
|------|--------|--------|
| 22 (SSH) | ✅ Open | Remote access |
| 80 (HTTP) | ✅ Open | Redirects to HTTPS |
| 443 (HTTPS) | ✅ Open | WordPress site |
| 3306 (MariaDB) | ❌ Denied | Internal only |
| 9000 (PHP-FPM) | ❌ Not exposed | Internal only |

TLS: self-signed certificate (365 days). Replace with Let's Encrypt for production.

---



###  Déploiement

Lancez le déploiement complet avec une seule commande :

```bash
ansible-playbook -i inventory/inventory.ini playbooks/main.yml -K
```

### Accès aux Services
Service	URL	Identifiants
**Souad Hilal VM1** 
**WordPress**	https://shilal.duckdns.org	usra / 123456
**Tableau de bord WP**	https://shilal.duckdns.org/wp-admin	usra / 123456
**phpMyAdmin**	https://shilal.duckdns.org/phpmyadmin/	user / pass

**Yousra Bouzafour VM2** 
**WordPress**	https://ybouzafo.duckdns.org	usra / 123456
**Tableau de bord WP**	https://ybouzafo.duckdns.org/wp-admin	usra / 123456
**phpMyAdmin**	https://ybouzafo.duckdns.org/phpmyadmin/	user / pass



### 🛠️ Maintenance & Commandes Utiles###

**Vérifier l'état du Firewall :**

```bash
sudo ufw status verbose
```

**Voir les logs des conteneurs en direct:**

```bash
cd ~/roles/docker-compose && docker compose logs -f
```

**Relancer un service spécifique (ex: nginx):**

```bash
docker compose up -d --force-recreate nginx
```




 


