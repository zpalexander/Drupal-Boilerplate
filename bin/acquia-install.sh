#!/bin/bash

# Check if there is a config file
# Create if none
if [ ! -f config ]; then
  touch acquia-config
  echo -e "acquia_drush_alias_remote=\"\"\ndrush_alias_local=\"\"\nvdd_project_name=\"\"\nsite_config_module=\"\"\nsite_child_theme=\"\"" > config
  echo "Please supply the necessary information for this script in the \"acquia-config\" file. Note that said file is ignored in git, therefore it should not be committed."
  exit 1
fi

# Include config file to import variables defined there
source acquia-config

# Check if config's variables have been set
if [ -z "$acquia_drush_alias_remote" ] || [ -z "$drush_alias_local" ] || [ -z "$vdd_project_name" ] || [ -z "$site_config_module" ] || [ -z "$site_child_theme" ]; then
  echo "Please supply the necessary information to the acquia-config file."
  exit 1
fi

# Install drush
sudo apt-get install -y drush

# Install Drupal
drush si -y --db-url='mysql://root:root@localhost/'$vdd_project_name --site-name=$vdd_project_name

# Synchronize databases
src="dev"
dest="local"
drush @$acquia_drush_alias_remote sql-drop -y
drush sql-sync @$acquia_drush_alias_remote @$drush_alias_local --yes
drush @$drush_alias_local upwd admin --password="elephant"
drush -y rsync "@$acquia_drush_alias_remote:%files/" "@$drush_alias_local:%files"
drush cc all

# Change password to "elephant"
drush upwd admin --password="elephant"
echo "Changed password to \"elephant\"."

# Enable the site config module just in case, and revert all features just in case
echo "Making sure the site's modules are all set up..."
drush en -y $site_config_module
drush fra -y
drush cc all

# Install Compass in the child theme
echo "Setting up Compass..."
command curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
rvm install ruby-latest
sudo gem install bundle
cd ../docroot/sites/all/themes/$site_child_theme
bundle
compass compile
exit
