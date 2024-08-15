#!/bin/bash

echo "DB_USER: $DB_USER"

# Перевірка, чи існує користувач
USER_EXISTS=$(mysql -u root -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$DB_USER')")

if [ "$USER_EXISTS" != 1 ]; then
    # Створення нового користувача з доступом з будь-якого хосту
    echo "Створення користувача MySQL '$DB_USER' з доступом з будь-якого хосту..."
    mysql -u root -e "CREATE USER \"$DB_USER\"@'%' IDENTIFIED BY \"$DB_PASS\";" || { echo "Помилка створення користувача"; exit 1; }
else
    echo "Користувач '$DB_USER' вже існує. Пропускаємо створення користувача."
fi

# Надання повних привілеїв новому користувачу
echo "Надання привілеїв користувачу '$DB_USER'..."
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO \"$DB_USER\"@'%' WITH GRANT OPTION;" || { echo "Помилка надання привілеїв"; exit 1; }

# Створення бази даних
#echo "Створення бази даних '$DB_NAME'..."
#mysql -u root -e "CREATE DATABASE $DB_NAME;" || { echo "Помилка створення бази даних"; exit 1; }

# Надання користувачу повного доступу до нової бази даних
#echo "Надання привілеїв користувачу '$DB_USER' для бази даних '$DB_NAME'..."
#mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO \"$DB_USER\"@'%' WITH GRANT OPTION;" || { echo "Помилка надання привілеїв до бази даних"; exit 1; }

# Оновлення привілеїв
echo "Оновлення привілеїв..."
mysql -u root -e "FLUSH PRIVILEGES;" || { echo "Помилка оновлення привілеїв"; exit 1; }

# Перезапуск MySQL для застосування змін
echo "Перезапуск MySQL сервера..."
sudo systemctl restart mysql || { echo "Помилка перезапуску MySQL"; exit 1; }

# Вивід інформації про завершення операцій
echo "Операції по налаштуванню MySQL завершено."

