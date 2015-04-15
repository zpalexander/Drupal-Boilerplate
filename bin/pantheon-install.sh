#!/bin/bash

# Check if there is a config file
# Create if none
if [ ! -f config ]; then
  touch pantheon-config
  echo -e "pantheon_email=\"\"\npantheon_pswd=\"\"\npantheon_site=\"\"\nvdd_project_name=\"\"\nsite_config_module=\"\"\nsite_child_theme=\"\"" > config
  echo "Please supply the necessary information for this script in the \"pantheon-config\" file. Note that said file is ignored in git, therefore it should not be committed."
  exit 1
fi

# Include config file to import variables defined there
source pantheon-config

# Check if config's variables have been set
if [ -z "$pantheon_email" ] || [ -z "$pantheon_pswd" ] || [ -z "$pantheon_site" ] || [ -z "$vdd_project_name" ] || [ -z "$site_config_module" ] || [ -z "$site_child_theme" ]; then
  echo "Please supply the necessary information to the pantheon-config file."
  exit 1
fi

# Install drush
sudo apt-get install -y drush

# Install Drupal using the Pantheon profile
drush si -y pantheon --db-url='mysql://root:root@localhost/'$vdd_project_name --site-name=$vdd_project_name

# Check if /usr/local/bin/terminus exists
if [ ! -f /usr/local/bin/terminus ]; then
  echo "Downloading Pantheon CLI (Terminus)"
  sudo apt-get install curl
  sudo curl https://github.com/pantheon-systems/cli/releases/download/0.5.5/terminus.phar -L -o /usr/local/bin/terminus && sudo chmod +x /usr/local/bin/terminus
fi

# Login to Terminus
echo "Logging into terminus"
sudo terminus auth login $pantheon_email --password=$pantheon_pswd --silent

# Download the latest site database backup
echo "Downloading the database from Pantheon."
sudo terminus site backup get --site=$pantheon_site --env=dev --element=database --to-directory="./" --latest

# Import the Backup into the local database
echo "Importing the downloaded database into the local site database."
gzip -d *.gz
mysql -uroot -proot $vdd_project_name < *.sql
rm *.sql

# Download the latest site files backup
echo "Downloading Public files from Pantheon and copying them to the local public files directory."
sudo terminus site backup get --site=$pantheon_site --env=dev --element=files --to-directory="./" --latest
echo "Extracting files to Public directory"
tar -xvzf *.tar.gz
if [ ! -d "../docroot/sites/default/files" ]; then
  mkdir ../docroot/sites/default/files
fi
mv files_dev/* ../docroot/sites/default/files/
rm -rf files_dev
rm *.tar.gz

# Change password to "elephant"
drush upwd admin --password="elephant"
echo "Changed password to \"elephant\"."

# Enable the site config module just in case, and revert all features just in case
echo "Making sure the site's modules are all set up..."
drush en -y $site_config_module
drush fra -y
drush cc all

# Install missing gems
echo "Setting up Compass..."
command curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
rvm install ruby-1.9.3
sudo gem install bundle
cd ../docroot/sites/all/themes/$site_child_theme
bundle
compass compile
exit
