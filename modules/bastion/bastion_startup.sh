sudo apt-get update -y
sudo apt-get install -y tinyproxy locales
sudo sh -c 'echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen'
sudo locale-gen en_US.UTF-8
