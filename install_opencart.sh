#!/bin/bash

source /etc/opencart-installer.conf

MYSQL_HOST=localhost
MYSQL_USERNAME=root
MYSQL_PASS=''

# -----------------------------

function download()
{
    echo -n "    "
    wget --progress=dot $URL -O $TEMPDIR/opencart.zip | grep --line-buffered "%" | \
        sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
    echo -ne "\b\b\b\b"
    echo " DONE"
}


while getopts ":p:u:d:t:v:m:n:f:h:e" opt; do
    case $opt in
        p)
            DESTINATION_PATH=$OPTARG
            # echo "-p was triggered, Parameter: $DESTINATION_PATH" >&2
            ;;
        e)
            EXTENSION=$OPTARG
            # echo "-e was triggered, Parameter: $EXTENSION" >&2
            ;;
        u)
            FOR_USER=$OPTARG
            # echo "-u was triggered, Parameter: $FOR_USER" >&2
            ;;
        d)
            DATABASE=$OPTARG
            # echo "-d was triggered, Parameter: $DATABASE" >&2
            ;;
        t)
            TEMPLATE=$OPTARG
            # echo "-t was triggered, Parameter: $TEMPLATE" >&2
            ;;
        v)
            VERSION=$OPTARG
            # echo "-v was triggered, Parameter: $VERSION" >&2
            ;;
           
        h)
             HOST=$OPTARG
            # echo "-h was triggered, Parameter: $HOST" >&2
            ;;

        m)
            DOMAIN=$OPTARG
            # echo "-m was triggered, Parameter: $DOMAIN" >&2
            ;;
        n)
            PROJECT_NAME=$OPTARG
            echo "Project Name given: $PROJECT_NAME" >&2
            ;;
        f)
            TRUNCATE=true
            echo "will truncate the database"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [ ! -d "$TEMPDIR" ]; then
mkdir $TEMPDIR;
fi

# -v <version> (version to install)
if [ -z "$VERSION" ]
then
    VERSION="current"
    echo "using default version: $CURRENT_VERSION" >&2
else
    echo "using version: $VERSION" >&2
fi


# -p <path> (current folder if none given)
if [ -z "$DESTINATION_PATH" ]
then
    if [ -z "$PROJECT_NAME" ]
    then
        DESTINATION_PATH="mystore"
        echo "no destination path/project name given, setting to: $PWD/mystore" >&2
    else
        DESTINATION_PATH=$PROJECT_NAME
        echo "no destination path given, setting to project name: $DESTINATION_PATH" >&2
    fi
else
    echo "destination path: $DESTINATION_PATH" >&2
fi

# -u <user> (current user if none given)
if [ -z "$FOR_USER" ]
then
    FOR_USER="$USER"
    echo "no user given, setting to: $FOR_USER" >&2
else
    echo "user: $FOR_USER" >&2
fi

# -h <hostname> (http://cheetasoft.gr/<domain> if none given)
if [ -z "$HOST" ]
then
  HOST="cheetasoft.gr"
echo "no hostname given, setting default: $HOST" >&2
else
    echo "host: $HOST" >&2
fi

# -m <domain> (http://<hostname>/mystore if none given)
if [ -z "$DOMAIN" ]
then
    if [ -z "$PROJECT_NAME" ]
    then
        DOMAIN="http://$HOST/mystore/"
        echo "no domain/project name given, setting default: $DOMAIN" >&2
    else
        DOMAIN="http://$HOST/$PROJECT_NAME/"
        echo "no domain given, setting with project name: $DOMAIN" >&2
    fi
else
    echo "domain: $DOMAIN" >&2
fi

# -d <database> (Error if none given)
if [ -z "$DATABASE" ]
then
    if [ -z "$PROJECT_NAME" ]
    then
        DATABASE="${FOR_USER}_mystore"
        echo "no database/project name given, setting default: $DATABASE" >&2
    else
        DATABASE="${FOR_USER}_${PROJECT_NAME}"
        echo "no database given, setting with project name: $DATABASE" >&2
    fi
else
    echo "database: $DATABASE" >&2
fi

# create path folder if not exists (this won't work if parent folder missing)
if [ ! -d "$DESTINATION_PATH" ]; then
    mkdir $DESTINATION_PATH
fi

# detect Operating System
OS=`uname`
echo $VERSION;
if [ $VERSION == stable ]
then
# purge tmp folder
rm -drf $TEMPDIR/upload

# download opencart
echo -n "Downloading $URL:"
download $URL
# extract opencart
unzip $TEMPDIR/opencart.zip "opencart-$CURRENT_VERSION/upload/*" -d $TEMPDIR
mv $TEMPDIR/opencart-$CURRENT_VERSION/upload $TEMPDIR/.
rm -drf $TEMPDIR/opencart-$CURRENT_VERSION
rm  $TEMPDIR/opencart.zip
# check if opencart is in tmp folder
if [ -f $TEMPDIR/upload/index.php ];
then
OPENCART_PATH=$TEMPDIR/upload
fi 
fi

# copy opencart
cp -r $OPENCART_PATH/* $DESTINATION_PATH
cp $OPENCART_PATH/.htaccess.txt $DESTINATION_PATH/.htaccess
cp $OPENCART_PATH/.gitignore $DESTINATION_PATH/.gitignore

# rename config files 
mv $DESTINATION_PATH/config-dist.php $DESTINATION_PATH/config.php
mv $DESTINATION_PATH/admin/config-dist.php $DESTINATION_PATH/admin/config.php

# change permissions
if [[ "$OS" == 'Linux' ]]; then
    # change permissions
    chown -R $FOR_USER:$FOR_USER $DESTINATION_PATH
    chmod -R 755 $DESTINATION_PATH

    chmod 0777 $DESTINATION_PATH/config.php
    chmod 0777 $DESTINATION_PATH/admin/config.php

    chmod 0777 $DESTINATION_PATH/system/cache/
    chmod 0777 $DESTINATION_PATH/system/logs/
    chmod 0777 $DESTINATION_PATH/image/
    chmod 0777 $DESTINATION_PATH/image/cache/
    chmod 0777 $DESTINATION_PATH/image/data/
    chmod 0777 $DESTINATION_PATH/download/
else
    icacls $DESTINATION_PATH /grant:r Everyone:RX /t

    icacls $DESTINATION_PATH/config.php /grant:r Everyone:F /t
    icacls $DESTINATION_PATH/admin/config.php /grant:r Everyone:F /t

    icacls $DESTINATION_PATH/system/cache/ /grant:r Everyone:F /t
    icacls $DESTINATION_PATH/system/logs/ /grant:r Everyone:F /t
    icacls $DESTINATION_PATH/image/ /grant:r Everyone:F /t
    icacls $DESTINATION_PATH/image/cache/ /grant:r Everyone:F /t
    icacls $DESTINATION_PATH/image/data/ /grant:r Everyone:F /t
    icacls $DESTINATION_PATH/download/ /grant:r Everyone:F /t
fi

# create database
if [[ "$MYSQL_PASS" == '' ]]; then
    echo "create database $DATABASE" | mysql -u $MYSQL_USERNAME
else
    echo "create database $DATABASE" | mysql -u $MYSQL_USERNAME -p$MYSQL_PASS
fi

# abort/exit if database creation fails
if [ $? -eq 0 ]; then
    echo "Database $DATABASE Created Successfully."
else
    echo "Error in database creation. Aborting."
    rm -rf $DESTINATION_PATH/
    exit 1
fi

# Wait for user to complete install before continuing
#read -p "Press [Enter] when OpenCart Installation Step 3 is finished."

# Check if Step 3 is indeed finished.
#echo "select * from oc_address" | mysql -u $MYSQL_USERNAME -p$MYSQL_PASS $DATABASE
#if [ $? -ne 0 ]; then
 #   echo "Step 3 not yet completed. Aborting."
 #   rm -rf $DESTINATION_PATH/
 #   echo "drop database $DATABASE" | mysql -u $MYSQL_USERNAME -p$MYSQL_PASS
 #   exit 1download()
{
    local url=$1
    echo -n "    "
    wget --progress=dot $url 2>&1 | grep --line-buffered "%" | \
        sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
    echo -ne "\b\b\b\b"
    echo " DONE"
}
#fi

echo "Installing opencart basic..."
if [[ "$MYSQL_PASS" == '' ]]; then
    php $DESTINATION_PATH/install/cli_install.php install --db_host $MYSQL_HOST --db_user $MYSQL_USERNAME --db_password "" --db_name $DATABASE --db_prefix oc_ --username admin --password admin123 --email admin@example.com --agree_tnc yes --http_server $DOMAIN
else
    php $DESTINATION_PATH/install/cli_install.php install --db_host $MYSQL_HOST --db_user $MYSQL_USERNAME --db_password $MYSQL_PASS --db_name $DATABASE --db_prefix oc_ --username admin --password admin123 --email admin@example.com --agree_tnc yes --http_server $DOMAIN
fi


# user can choose to truncate default opencart database (remove all products/categories/manufacturers)
# while true; do
#     read -p "Do you wish to truncate the database? (y/n): " yn
#     case $yn in
#         [Yy]* ) cat $TRUNCATE_FILE | mysql -u $MYSQL_USERNAME -p$MYSQL_PASS $DATABASE; break;;
#         [Nn]* ) break;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done

if $TRUNCATE; then
    echo "Truncating base opencart database..."
    if [[ "$MYSQL_PASS" == '' ]]; then
        cat $TRUNCATE_FILE | mysql -u $MYSQL_USERNAME $DATABASE
    else
        cat $TRUNCATE_FILE | mysql -u $MYSQL_USERNAME -p$MYSQL_PASS $DATABASE
    fi
fi

# read -p "Press [Enter] key to remove install folder."

# remove install folder
rm -rf $DESTINATION_PATH/install/

# install template 
# supported templates:
# 1. Journal v1.2.0 for opencart v1.5.5.1
if [ -z "$TEMPLATE" ]
then
    echo "No template given. Using default" >&2
    exit 1
else
    echo "Installing template: $TEMPLATE" >&2

    # journal
    if [ $TEMPLATE = "journal" ]; then
        cp -r $TEMPLATE_PATH_JOURNAL_v1_5_5_1/* $DESTINATION_PATH/
        chown -R $FOR_USER:$FOR_USER $DESTINATION_PATH
        if [[ "$MYSQL_PASS" == '' ]]; then
            cat $JOURNAL_IMAGE_SETUP_SQL | mysql -u $MYSQL_USERNAME $DATABASE
            cat $JOURNAL_MODULES_SETUP_SQL | mysql -u $MYSQL_USERNAME $DATABASE
        else
            cat $JOURNAL_IMAGE_SETUP_SQL | mysql -u $MYSQL_USERNAME -p$MYSQL_PASS $DATABASE
            cat $JOURNAL_MODULES_SETUP_SQL | mysql -u $MYSQL_USERNAME -p$MYSQL_PASS $DATABASE
        fi
    else
        echo "Template $TEMPLATE is not supported. Using default." >&2
    fi
fi

