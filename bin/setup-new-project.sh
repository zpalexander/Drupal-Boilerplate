#!/bin/bash

# Install drush
sudo apt-get install -y drush
drush cc all

# Download Drupal if the user hasn't already done so
echo "This script will set up your /sites/all directory and provide you with commonly used modules and themes."
echo "Do you wish to download Drupal into /docroot before beginning the /sites/all setup? Yes/No"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) rm ../docroot/README.md; drush dl drupal; mv drupal-*/* ../docroot/; rm -rf drupal-*; break;;
        No ) break;;
    esac
done

# Set up the /modules directory structure
cd ../docroot/sites/all
mkdir modules/contrib
mkdir modules/custom
mkdir modules/features

# Download common contrib modules
echo "Downloading and enabling commonly used contrib modules"
drush dl adminimal_admin_menu backup and migrate ctools date devel diff ds elements entity entityreference
drush dl features field_group find_content html5_tools imagecache_actions jquery_update
drush dl libraries link magic metatag panels panels_everywhere pathauto
drush dl seckit semantic_fields stage_file_proxy strongarm token views wysiwyg

# Enable common contrib modules
drush en -y adminimal_admin_menu backup and migrate ctools date devel diff ds elements entity entityreference
drush en -y features field_group find_content html5_tools imagecache_actions jquery_update
drush en -y libraries link magic metatag panels panels_everywhere pathauto
drush en -y seckit semantic_fields stage_file_proxy strongarm token views wysiwyg

# Download common parent themes
echo "Downloading commonly used base themes"
drush dl adminimal_theme aurora omega
drush theme set admin adminimal_theme

# Generate sub-theme if requested
echo "Would you like to create a sub-theme for Aurora, Omega, or neither? Aurora/Omega/Neither"
select theme in "Aurora" "Omega" "Neither"; do
  case $theme in
    Aurora ) sudo apt-get install python-software-properties python g++ make; sudo add-apt-repository ppa:chris-lea/node.js; sudo apt-get update; sudo apt-get install nodejs; sudo npm install -g npm; sudo npm-install -g yo generator-aurora; yo aurora; break;;
    Omega ) drush omega-wizard; break;;
    Neither ) break;;
  esac
done


