#!/bin/bash

# Оновлюємо пакети та встановлюємо MySQL Server
sudo apt-get update
sudo apt-get install -y mysql-server

# Повідомлення про успішну установку MySQL
echo "MySQL Server успішно встановлено."

# Налаштування MySQL для прослуховування лише на певних IP-адресах
sudo sed -i "s/^bind-address\s*=.*$/bind-address = 192.168.56.10/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Повідомлення про встановлення IP-адреси для приватної мережі
echo "IP-адреса для приватної мережі встановлена на 192.168.56.10."

# Перезапуск служби MySQL, щоб застосувати зміни
sudo systemctl restart mysql
