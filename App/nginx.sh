sudo apt-get install -y nginx
echo "server {
    listen 8080;
    server_name localhost;
    root /var/www/html/dist/test-app;
    server_tokens off;
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}" > /etc/nginx/sites-available/localhost.conf

cd /etc/nginx/sites-enabled
ln -s ../sites-available/localhost.conf
ls -l
sudo rm default

sudo rm -f /var/www/index.html
cp -r ~/app/dist /var/www/html/