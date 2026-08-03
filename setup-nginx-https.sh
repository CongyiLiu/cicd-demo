#!/bin/bash
# HTTPS リバースプロキシのセットアップスクリプト

# 自己署名証明書を生成
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/task-manager.key \
  -out /etc/ssl/certs/task-manager.crt \
  -subj '/CN=149.28.21.68/O=IBM Japan CICD Demo'

# Nginx設定を作成
cat > /etc/nginx/sites-available/task-manager << 'NGINX'
server {
    listen 443 ssl;
    server_name 149.28.21.68;

    ssl_certificate     /etc/ssl/certs/task-manager.crt;
    ssl_certificate_key /etc/ssl/private/task-manager.key;

    location /api/ {
        proxy_pass http://localhost:8080;
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Content-Type' always;
        if ($request_method = OPTIONS) {
            return 204;
        }
    }
}
NGINX

ln -sf /etc/nginx/sites-available/task-manager /etc/nginx/sites-enabled/task-manager
nginx -t && systemctl reload nginx && echo "Nginx HTTPS ready on port 443"
