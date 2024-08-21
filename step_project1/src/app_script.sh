#!/bin/bash

           #ENVIRONMENT SETUP FOR APPLICATION LAUNCH

    #Exporting environment variables from Vagrantfile to Bash
      echo "Exporting environment variables..."
      export DB_USER="$DB_USER"
      export DB_PASS="$DB_PASS"
      export DB_NAME="$DB_NAME"
      export DB_HOST="$DB_HOST"
      export DB_PORT="$DB_PORT"
      export APP_USER="$APP_USER"
      export APP_USER_PASS="$APP_USER_PASS"
      export APP_DIR="$APP_DIR"
      export PROJECT_DIR="$PROJECT_DIR"

     #Updating and installing necessary packages
       echo "Updating the system and installing Java JDK, Git, Maven, MySQL client..."
       sudo apt-get update && sudo apt-get install -y openjdk-11-jdk git maven mysql-client || { echo "Package installation failed"; exit 1; }

          #CREATING USER AND WORKING DIRECTORIES

    #Creating application user if it doesn't exist
       echo "Creating user $APP_USER if it doesn't exist..."
       if ! id -u $APP_USER > /dev/null 2>&1; then
         sudo useradd -m -s /bin/bash $APP_USER || { echo "Failed to create user $APP_USER"; exit 1; }
         echo "$APP_USER:$APP_USER_PASS" | sudo chpasswd || { echo "Failed to set password for $APP_USER"; exit 1; }
       fi

    #Creating $APP_DIR directory in the user's home folder
      echo "Creating $APP_DIR directory in the home folder of user $APP_USER..."
      sudo mkdir -p /home/$APP_USER/$APP_DIR || { echo "Failed to create directory $APP_DIR"; exit 1; }
      echo "$APP_DIR directory created in the home folder of user $APP_USER."

    #Creating $PROJECT_DIR directory in the user's home folder
      echo "Creating $PROJECT_DIR directory in the home folder of user $APP_USER..."
      sudo mkdir -p /home/$APP_USER/$PROJECT_DIR || { echo "Failed to create directory $APP_DIR"; exit 1; }
      echo "$PROJECT_DIR directory created in the home folder of user $APP_USER."

      FULL_APP_DIR="/home/$APP_USER/$APP_DIR"
      FULL_PROJECT_DIR="/home/$APP_USER/$PROJECT_DIR"

          #CLONING THE REPOSITORY      

       if [ -d "$FULL_PROJECT_DIR" ]; then
        echo "$PROJECT_DIR directory exists."
        if [ "$(ls -A $FULL_PROJECT_DIR)" ]; then
          echo "$PROJECT_DIR directory is not empty. Skipping cloning."
        else
          echo "$PROJECT_DIR directory is empty. Starting cloning..."
          sudo git clone https://gogomaxgo:glpat-e2fXKWf-1g_ahyYFFrHY@gitlab.com/dan-it/groups/devops5.git $FULL_PROJECT_DIR || { echo "Repository cloning failed"; exit 1; }
        fi
      else
        echo "$PROJECT_DIR directory does not exist. Creating and cloning..."
       sudo mkdir -p $FULL_PROJECT_DIR
       sudo git clone https://gogomaxgo:glpat-e2fXKWf-1g_ahyYFFrHY@gitlab.com/dan-it/groups/devops5.git $FULL_PROJECT_DIR || { echo "Repository cloning failed"; exit 1; }
      fi

          #CHECKING DIRECTORIES AND FILES IN THE REPOSITORY FOR MAVEN SETUP AND EXECUTION

    #Searching for the PetClinic folder
      echo "Searching for the PetClinic folder inside the project $FULL_PROJECT_DIR..."
      PETCLINIC_DIR=$(find "$FULL_PROJECT_DIR" -type d -name "PetClinic" | head -n 1)

      if [ -z "$PETCLINIC_DIR" ]; then
          echo "Error: PetClinic folder not found in $FULL_PROJECT_DIR"
          exit 1
       else
          echo "PetClinic folder found at: $PETCLINIC_DIR"
       fi

     #Checking for the mvnw file and making it executable
       if [ ! -f "$PETCLINIC_DIR/mvnw" ]; then
           echo "Error: mvnw file not found in the $PETCLINIC_DIR folder"
           exit 1
       else
            echo "Making mvnw file executable..."
           chmod +x "$PETCLINIC_DIR/mvnw" || { echo "Failed to make mvnw executable"; exit 1; }
       fi

   #Searching for the target folder
       echo "Searching for the target folder inside $PETCLINIC_DIR..."
       TARGET_DIR=$(find "$PETCLINIC_DIR" -type d -name "target" | head -n 1)

        if [ -n "$TARGET_DIR" ]; then
           echo "Target folder found at: $TARGET_DIR"
        else
            echo "Target folder not found."
       fi

    #Checking for the JAR file
       if [ -f "$TARGET_DIR"/*.jar ]; then
          echo "The application is already built. Re-running Maven is not necessary."
       else
           echo "JAR file not found. Re-running Maven is required."
   
    #Run Maven build if the file is not found
      cd $PETCLINIC_DIR
      sudo ./mvnw test package || { echo "Maven execution failed"; exit 1; }

      fi

          #RUNNING THE APPLICATION

    #Updating JAR_FILE after the build
      JAR_FILE=$(find "$TARGET_DIR" -type f -name "*.jar" | head -n 1)
      echo "File $JAR_FILE exists"

    #Checking for the JAR file in the destination directory
      DEST_JAR_FILE="$FULL_APP_DIR/$(basename "$JAR_FILE")"
      echo "Destination file is located at $DEST_JAR_FILE"

      if [ -f "$DEST_JAR_FILE" ]; then
         echo "JAR file already exists in the $FULL_APP_DIR directory. Skipping copy."
      else
    #Copying the JAR file to the $FULL_APP_DIR directory
         echo "Copying the JAR file to the $FULL_APP_DIR directory..."
         sudo cp "$JAR_FILE" $FULL_APP_DIR || { echo "Failed to copy JAR file"; exit 1; }
      fi

    #Adding delay
      sleep 2

    # Running the JAR file
      echo "Running the JAR file from the $FULL_APP_DIR directory..."


    # Debugging: print environment variable values
       echo "DB_HOST: $DB_HOST"
       echo "DB_NAME: $DB_NAME"
       echo "DB_USER: $DB_USER"
       echo "DB_PASS: $DB_PASS"
       echo "APP_USER: $APP_USER"
       echo "APP_USER_PASS: $APP_USER_PASS"
       echo "APP_DIR: $APP_DIR"
       echo "PROJECT_DIR: $PROJECT_DIR"


     sudo -u $APP_USER java -jar \
     -DMYSQL_URL=jdbc:mysql://$DB_HOST/$DB_NAME?serverTimezone=UTC \
     -DMYSQL_USER="$DB_USER" \
     -DMYSQL_PASS="$DB_PASS" \
     -Dspring.profiles.active=mysql \
     "$DEST_JAR_FILE" >/dev/null 2>&1 &

      if [ $? -ne 0 ]; then
        echo "Failed to run JAR file"
        exit 1
      else
        echo "All operations completed successfully."
      fi

    #Setting environment variables and running the application
      echo "Setting environment variables and running the application..."
      echo "export DB_HOST=$DB_HOST" >> /home/$APP_USER/.bashrc
      echo "export DB_PORT=$DB_PORT" >> /home/$APP_USER/.bashrc
      echo "export DB_USER=$DB_USER" >> /home/$APP_USER/.bashrc
      echo "export DB_PASS=$DB_PASS" >> /home/$APP_USER/.bashrc
      echo "export DB_NAME=$DB_NAME" >> /home/$APP_USER/.bashrc
      echo "source ~/.bashrc" >> /home/$APP_USER/.bashrc

      echo "All operations completed successfully."
