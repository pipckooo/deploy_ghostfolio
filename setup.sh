#!/bin/bash

set -e

until ping -c 1 deb.nodesource.com; do
    echo "Waiting for internet..."
    sleep 5
done

apt-get update -y
apt-get install -y nginx certbot python3-certbot-nginx curl postgresql postgresql-contrib

# Setup PostgreSQL Database
sudo -u postgres psql -c "CREATE USER ghostfolio WITH PASSWORD 'ghostfolio';" || true
sudo -u postgres psql -c "CREATE DATABASE ghostfolio OWNER ghostfolio;" || true

rm -f /etc/nginx/sites-enabled/default
cat << 'EON' > /etc/nginx/sites-available/reverse-proxy.conf
server {
    listen 80;
    server_name task-3-2-4.fox-tier-task.pp.ua;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EON

ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/ || true
systemctl restart nginx

certbot --nginx -d task-3-2-4.fox-tier-task.pp.ua --non-interactive --agree-tos -m ${certbot_email} --redirect || true

# Force Rebuild