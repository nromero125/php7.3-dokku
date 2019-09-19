#!/bin/bash
sudo chgrp -R www-data storage /app/bootstrap/cache
sudo chmod -R ug+rwx storage /app/bootstrap/cache
php /app/artisan migrate
exec /usr/bin/supervisord --nodaemon -c /etc/supervisor/supervisord.conf