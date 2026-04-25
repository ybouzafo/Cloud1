# #!/bin/bash

# sleep 10

# wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$DB_HOST --allow-root --skip-check
# wp core install --url=$DOMAIN_NAME --title=$WP_ADMIN_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root
# wp user create $WP_USER_LOGIN $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --role=$WP_USER_ROLE --allow-root
# /usr/sbin/php-fpm7.4 -F


#!/bin/bash

# 1. Attendre que la base de données soit prête
# Le sleep 10 est bien, mais MariaDB sur le Cloud peut mettre plus de temps à démarrer.
sleep 15

# 2. Se déplacer dans le bon répertoire (important pour WP-CLI)
cd /var/www/html/

# 3. Créer le fichier wp-config.php seulement s'il n'existe pas (Idempotence)
if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=$DB_HOST \
        --allow-root --skip-check
fi

# 4. Installer WordPress seulement si ce n'est pas déjà fait
if ! wp core is-installed --allow-root; then
    wp core install \
        --url=$DOMAIN_NAME \
        --title=$WP_ADMIN_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root
    
    # 5. Créer le second utilisateur
    wp user create $WP_USER_LOGIN $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=$WP_USER_ROLE \
        --allow-root
fi

# 6. Lancement de PHP-FPM en premier plan (-F)
# Note : Sur Debian oldstable, vérifie si c'est bien php-fpm7.4 ou utilise un chemin générique
echo "Démarrage de WordPress..."
exec $(find /usr/sbin -name "php-fpm*" | head -n 1) -F