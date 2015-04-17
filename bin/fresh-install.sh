#!/bin/bash

# Check if there is a config file
# Create if none
if [ ! -f config ]; then
  touch fresh-config
  echo -e "vdd_project_name=\"\"\nsite_config_module=\"\"\nsite_child_theme=\"\"" > config
  echo "Please supply the necessary information for this script in the \"fresh-config\" file. Note that said file is ignored in git, therefore it should not be committed."
  exit 1
fi

# Include config file to import variables defined there
source fresh-config

# Check if config's variables have been set
if [ -z "$vdd_project_name" ] || [ -z "$site_config_module" ] || [ -z "$site_child_theme" ]; then
  echo "Please supply the necessary information to the fresh-config file."
  exit 1
fi

# Install drush
sudo apt-get install -y drush
drush cc all

# Install Drupal
cd ../docroot/
drush si -y --db-url='mysql://root:root@localhost/'$vdd_project_name --site-name=$vdd_project_name

###########
### @TODO
### ADD DATABASE AND FILE SYNC
### FOR YOUR SELF-HOSTED PROJECT HERE
###########

# Change password to "elephant"
drush upwd admin --password="elephant"
echo "Changed password to \"elephant\"."

# Enable the site config module and revert all features
echo "Making sure the site's modules are all set up..."
drush en -y features
drush en -y $site_config_module
drush fra -y
drush dis -y overlay
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
