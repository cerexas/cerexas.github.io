#!/bin/bash

# Exit on error and print each command that is executed
set -e
set -x

echo "Running email wizard..."
curl -LO larbs.xyz/emailwiz.sh
bash emailwiz.sh

echo "Adding mail users..."
for user in post gunnar ole; do
    useradd -m -G mail "$user"
done

echo "Setting passwords..."
echo "Set password for user post"
passwd post
echo "Set password for user gunnar"
passwd gunnar
echo "Set password for user ole"
passwd ole

echo "Opening port 443..."
ufw allow 443 && ufw status verbose >> firewall

echo "Getting .bashrc file..."
curl -Lo .bashrc https://ghalv.github.io/bashrc #; source ~/.bashrc

echo "Installing necessary packages..."
apt-get install -y nginx rsync git

echo "Setting up nginx configuration..."
rm -f /etc/nginx/sites-enabled/default
curl -Lo /etc/nginx/sites-available/cerex https://cerexas.github.io/cerex
ln -s /etc/nginx/sites-available/cerex /etc/nginx/sites-enabled/cerex
systemctl reload nginx

echo "Setting up website..."
git clone https://github.com/cerexas/cerexas.github.io /var/www/cerex
rm -rf /var/www/cerex/.git

echo "Running certbot..."
certbot --nginx

echo "Add the certbot renew command to the cron jobs list"		# Not working!
(crontab -l 2>/dev/null; echo "0 0 1 * * certbot renew") | crontab -

echo "Set shell to bash"
chsh -s /bin/bash $USER

echo "Script has finished successfully! Now 1) source .bashrc, 2) disable pw login and 3) hide nginx version."
echo "By default, Nginx and most other webservers automatically show their version number on error pages. It's a good idea to disable this from happening because if an exploit comes out for your server software, someone could exploit it. Open the main Nginx config file /etc/nginx/nginx.conf and find the line # server_tokens off;. Uncomment it, and reload Nginx."
