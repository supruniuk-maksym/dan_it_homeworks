#!/bin/bash

# Перевірка значень змінних
if [ -z "$DB_USER" ] || [ -z "$DB_NAME" ]; then
    echo "Помилка: DB_USER або DB_NAME не встановлені."
    exit 1
fi

echo "DB_USER: $DB_USER"
echo "DB_NAME: $DB_NAME"

# Перевірка, чи існує база даних
DB_EXISTS=$(mysql -u root -e "SHOW DATABASES LIKE '$DB_NAME';" | grep "$DB_NAME" > /dev/null; echo "$?")

if [ $DB_EXISTS -eq 0 ]; then
    echo "База даних '$DB_NAME' вже існує. Пропускаємо створення."
else
    # Створення бази даних
    echo "Створення бази даних '$DB_NAME'..."
    mysql -u root -e "CREATE DATABASE $DB_NAME;" || { echo "Помилка створення бази даних"; exit 1; }
fi

# Надання користувачу повного доступу до нової бази даних
echo "Надання привілеїв користувачу '$DB_USER' для бази даних '$DB_NAME'..."
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO \"$DB_USER\"@'%' WITH GRANT OPTION;" || { echo "Помилка надання привілеїв до бази даних"; exit 1; }

# Оновлення привілеїв
echo "Оновлення привілеїв..."
mysql -u root -e "FLUSH PRIVILEGES;" || { echo "Помилка оновлення привілеїв"; exit 1; }

# Вивід інформації про завершення операцій
echo "Операції по налаштуванню нової бази MySQL завершено."



