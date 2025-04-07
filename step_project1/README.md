


# Setting Up the Working Environment for Petclinic
To launch two virtual machines (database and application) using Vagrant on Parallels, you need to install Vagrant. Initialize a folder for Vagrant and copy the following files from the repository into this folder:

* Vagrantfile
* app_script.sh
* db_setup.sh
* mysql_user_setup.sh
* new_database_setup.sh

  
Before running the vagrant up command, make a copy of the environment variables for your setup in .zprofile or .bashrcIi:


export DB_USER=dev1
export DB_PASS=petclinic
export DB_NAME=petclinic_db

export DB_HOST=192.168.56.10
export DB_PORT=3306


export APP_USER=dev10
export APP_USER_PASS=dev10
export APP_DIR=petclinic_app
export PROJECT_DIR=petclinic_project


# Видалення пробілів
export DB_USER=$(echo $DB_USER | tr -d '[:space:]')
export DB_PASS=$(echo $DB_PASS | tr -d '[:space:]')
export DB_NAME=$(echo $DB_NAME | tr -d '[:space:]')

export DB_HOST=$(echo $DB_USER | tr -d '[:space:]')
export DB_PORT=$(echo $DB_USER | tr -d '[:space:]')

export APP_USER=$(echo $APP_USER | tr -d '[:space:]')
export APP_USER_PASS=$(echo $APP_USER_PASS | tr -d '[:space:]')
export APP_DIR=$(echo $APP_DIR | tr -d '[:space:]')
export PROJECT_DIR=$(echo $PROJECT_DIR | tr -d '[:space:]')

# YOU NEED RUN PROVISION AFTER VAGRANR UP SET APLLICATIONS. 
# YOUR APP WILL BE AVAILIBLE ON 192.168.56.11:8080
