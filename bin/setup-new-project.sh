#!/bin/bash

# Check if there is a contrib module list
# Create if none
if [ ! -f module-list ]; then
  touch module-list
  echo -e "module_list=\"\"" > module-list
  echo "Please supply a list of contrib modules you'd like included in your project. Note that said file is ignored in git, therefore it should not be committed."
  exit 1
fi

# Include config file to import variables defined there
source module-list

# Install drush
sudo apt-get install -y drush

# Download Drupal if the user hasn't already done so
echo "This script will set up your /sites/all directory and provide you with commonly used modules and themes."
echo "Do you wish to download Drupal into /docroot before beginning the /sites/all setup?"
echo "Enter 1 for Yes and 2 for No"
PS3="Please enter your choice: "

cd ../docroot/

select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "Downloading Drupal"; rm README.md &> /dev/null; drush dl drupal; mv drupal-*/* ../docroot/; rm -rf drupal-*; break;;
        * ) break;;
    esac
done

# Set up the /modules directory structure
cd sites/all
mkdir modules/contrib
mkdir modules/custom
mkdir modules/features

# Download common contrib modules
echo "Downloading desired contrib modules"
drush dl $module_list

# Download common parent themes
echo "Downloading commonly used base themes"
drush dl adminimal_theme aurora omega

# Generate a site config feature
echo "Generating your site config feature"
cd ../../../bin/
bash generate-config-feature.sh

# Generate sub-theme if requested
echo "Would you like to create a sub-theme?"
echo "Enter 1 for Yes and 2 for No"
select theme in "Yes" "No"; do
  case $theme in
    Yes ) cd ../docroot/sites/all/themes/; sudo apt-get install python-software-properties python g++ make -y; sudo add-apt-repository ppa:chris-lea/node.js -y; sudo apt-get update; sudo apt-get install nodejs -y; sudo npm install -g npm; sudo gem install bundle; sudo npm install -g yo generator-aurora -y; yo aurora; break;;
    * ) break;;
  esac
done

echo "Your new project is scaffolded."
