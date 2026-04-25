FROM debian:oldstable

# 1. Installation des dépendances (regroupées pour l'optimisation)
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    php-fpm \
    php-mysql \
    mariadb-client \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 2. Configuration de PHP-FPM pour écouter sur le port 9000
# On modifie le fichier de pool par défaut (www.conf) qui est le standard
RUN sed -i 's|listen = /run/php/php.*-fpm.sock|listen = 9000|g' /etc/php/*/fpm/pool.d/www.conf

# 3. Création du dossier pour le socket PHP (nécessaire pour le démarrage du service)
RUN mkdir -p /run/php

# 4. Installation de WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# 5. Préparation du répertoire de travail
WORKDIR /var/www/html/

# 6. Téléchargement de WordPress
RUN wp core download --allow-root

# 7. Gestion du script de configuration
COPY ./tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 9000

# Utilisation du chemin absolu pour le script
ENTRYPOINT ["/bin/bash", "/usr/local/bin/script.sh"]