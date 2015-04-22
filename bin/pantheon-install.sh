#!/bin/bash

# Check if there is a config file
# Create if none
if [ ! -f pantheon-config ]; then
  touch pantheon-config
  echo -e "pantheon_email=\"\"\npantheon_pswd=\"\"\npantheon_site=\"\"\nvdd_project_name=\"\"\nsite_config_module=\"\"\nsite_child_theme=\"\"\nsite_parent_theme=\"\"" > pantheon-config
  echo "Please supply the necessary information for this script in the \"pantheon-config\" file. Note that said file is ignored in git, therefore it should not be committed."
  exit 1
fi

# Include config file to import variables defined there
source pantheon-config

# Check if config's variables have been set
if [ -z "$pantheon_email" ] || [ -z "$pantheon_pswd" ] || [ -z "$pantheon_site" ] || [ -z "$vdd_project_name" ] || [ -z "$site_config_module" ] || [ -z "$site_child_theme" ] || [ -z "$site_parent_theme" ]; then
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

# Enable the site configuration
## Turn on and revert the config
echo "Making sure the site's modules are all set up..."
drush en -y features
drush en -y $site_config_module
drush fra -y
drush pm-enable -y $site_child_theme $site_parent_theme
drush vset -y theme_default $site_child_theme
## Set up the admin interface
drush pm-enable -y adminimal
drush vset -y admin_theme adminimal
drush dis -y overlay
## Clear all caches
drush cc all

# Install Compass in the child theme
echo "Setting up Compass..."
sudo apt-get install ruby-rvm -y
rvm install ruby-latest
sudo gem install bundle
cd ../docroot/sites/all/themes/$site_child_theme
bundle
compass compile
exit
