#!/bin/bash

           #ПІДГОТОВКА СЕРЕДОВИЩА ДЛЯ ЗАПУСКУ АПЛІКЕЙШН

    #Експорт змінних середовища з Vagrantfile у Bash
      echo "Експортуємо змінні середовища..."
      export DB_HOST="$DB_HOST"
      export DB_PORT="$DB_PORT"
      export APP_USER="$APP_USER"
      export APP_USER_PASS="$APP_USER_PASS"
      export APP_DIR="$APP_DIR"
      export PROJECT_DIR="$PROJECT_DIR"

     #Оновлення і встановлення необхідних пакетів
       echo "Оновлення системи і встановлення Java JDK, Git, Maven, MySQL клієнта..."
       sudo apt-get update && sudo apt-get install -y openjdk-11-jdk git maven mysql-client || { echo "Помилка встановлення пакетів"; exit 1; }

          #СТВОРЕННЯ КОРИСТУВАЧА І РОБОЧИХ ПАПОК

    #Створення користувача для застосунку, якщо він ще не існує
       echo "Створення користувача $APP_USER, якщо він не існує..."
       if ! id -u $APP_USER > /dev/null 2>&1; then
         sudo useradd -m -s /bin/bash $APP_USER || { echo "Помилка створення користувача $APP_USER"; exit 1; }
         echo "$APP_USER:$APP_USER_PASS" | sudo chpasswd || { echo "Помилка встановлення пароля для $APP_USER"; exit 1; }
       fi

    #Створення директорії $APP_DIR у домашній папці користувача
      echo "Створення директорії $APP_DIR у домашній папці користувача $APP_USER..."
      sudo mkdir -p /home/$APP_USER/$APP_DIR || { echo "Помилка створення директорії $APP_DIR"; exit 1; }
      echo "Директорію $APP_DIR створено у домашній папці користувача $APP_USER."

    #Створення директорії $PROJECT_DIR у домашній папці користувача
      echo "Створення директорії $PROJECT_DIR у домашній папці користувача $APP_USER..."
      sudo mkdir -p /home/$APP_USER/$PROJECT_DIR || { echo "Помилка створення директорії $APP_DIR"; exit 1; }
      echo "Директорію $PROJECT_DIR створено у домашній папці користувача $APP_USER."

      FULL_APP_DIR="/home/$APP_USER/$APP_DIR"
      FULL_PROJECT_DIR="/home/$APP_USER/$PROJECT_DIR"

          #КЛОНУВАННЯ РЕПОЗІТОРІЮ      

       if [ -d "$FULL_PROJECT_DIR" ]; then
        echo "Директорія $PROJECT_DIR існує."
        if [ "$(ls -A $FULL_PROJECT_DIR)" ]; then
          echo "Директорія $PROJECT_DIR не пуста. Клонування пропущено."
        else
          echo "Директорія $PROJECT_DIR пуста. Починаємо клонування..."
          sudo git clone https://gogomaxgo:glpat-e2fXKWf-1g_ahyYFFrHY@gitlab.com/dan-it/groups/devops5.git $FULL_PROJECT_DIR || { echo "Помилка клонування репозиторію"; exit 1; }
        fi
      else
        echo "Директорія $PROJECT_DIR не існує. Створюємо і клонування..."
       sudo mkdir -p $FULL_PROJECT_DIR
       sudo git clone https://gogomaxgo:glpat-e2fXKWf-1g_ahyYFFrHY@gitlab.com/dan-it/groups/devops5.git $FULL_PROJECT_DIR || { echo "Помилка клонування репозиторію"; exit 1; }
      fi

          #ПЕРЕВІРКА ПАПОК І ФАЙЛІВ В РЕПОЗІТОРІЇ ДЛЯ  ВСТАНОВЛЕННЯ МАВЕН І ЙОГО ЗАПУСК

    #Пошук папки PetClinic
      echo "Пошук папки PetClinic всередині проекту $FULL_PROJECT_DIR..."
      PETCLINIC_DIR=$(find "$FULL_PROJECT_DIR" -type d -name "PetClinic" | head -n 1)

      if [ -z "$PETCLINIC_DIR" ]; then
          echo "Помилка: папка PetClinic не знайдена в $FULL_PROJECT_DIR"
          exit 1
       else
          echo "Знайдено папку PetClinic за шляхом: $PETCLINIC_DIR"
       fi

     #Перевірка наявності файлу mvnw та робимо його виконуваним
       if [ ! -f "$PETCLINIC_DIR/mvnw" ]; then
           echo "Помилка: файл mvnw не знайдено в папці $PETCLINIC_DIR"
           exit 1
       else
            echo "Робимо файл mvnw виконуваним..."
           chmod +x "$PETCLINIC_DIR/mvnw" || { echo "Не вдалося зробити mvnw виконуваним"; exit 1; }
       fi

   #Пошук папки target
       echo "Пошук папки target всередині $PETCLINIC_DIR..."
       TARGET_DIR=$(find "$PETCLINIC_DIR" -type d -name "target" | head -n 1)

        if [ -n "$TARGET_DIR" ]; then
           echo "Знайдено папку target за шляхом: $TARGET_DIR"
        else
            echo "Папка target не знайдена."
       fi

    #Перевірка наявності JAR-файлу
       if [ -f "$TARGET_DIR"/*.jar ]; then
          echo "Застосунок вже зібраний. Повторний запуск Maven не потрібен."
       else
           echo "JAR-файл не знайдено. Потрібен повторний запуск Maven."
   
    #Виконати Maven збірку, якщо файл не знайдено
      cd $PETCLINIC_DIR
      sudo ./mvnw test package || { echo "Помилка запуску Maven"; exit 1; }

      fi

          #ЗАПУСК ЗАСТОСУНКУ

    #Оновлення JAR_FILE після збірки
      JAR_FILE=$(find "$TARGET_DIR" -type f -name "*.jar" | head -n 1)
      echo "Файл $JAR_FILE існує"

    #Перевірка наявності JAR-файлу в цільовій директорії
      DEST_JAR_FILE="$FULL_APP_DIR/$(basename "$JAR_FILE")"
      echo "Цільовий Файл знаходится за адресою $DEST_JAR_FILE"

      if [ -f "$DEST_JAR_FILE" ]; then
         echo "JAR-файл вже існує в директорії $FULL_APP_DIR. Копіювання пропущено."
      else
    #Копіювання JAR-файлу в директорію $FULL_APP_DIR
         echo "Копіювання JAR-файлу в директорію $FULL_APP_DIR..."
         sudo cp "$JAR_FILE" $FULL_APP_DIR || { echo "Помилка копіювання JAR-файлу"; exit 1; }
      fi

    #Додати затримку
      sleep 2

    #Запуск JAR-файлу
      echo "Запуск JAR-файлу з директорії $FULL_APP_DIR..."
      sudo -u $APP_USER java -jar "$DEST_JAR_FILE" || { echo "Помилка запуску JAR-файлу"; exit 1; }

    #Налаштування змінних середовища і запуск застосунку
      echo "Налаштування змінних середовища і запуск застосунку..."
      echo "export DB_HOST=$DB_HOST" >> /home/$APP_USER/.bashrc
      echo "export DB_PORT=$DB_PORT" >> /home/$APP_USER/.bashrc
      echo "export DB_USER=$DB_USER" >> /home/$APP_USER/.bashrc
      echo "export DB_PASS=$DB_PASS" >> /home/$APP_USER/.bashrc
      echo "export DB_NAME=$DB_NAME" >> /home/$APP_USER/.bashrc
      echo "source ~/.bashrc" >> /home/$APP_USER/.bashrc

      echo "Всі операції завершено успішно."


