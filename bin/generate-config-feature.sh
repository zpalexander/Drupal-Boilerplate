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

cd ../docroot/sites/all/modules/features

# Take user input for the site config feature's human and machine names
echo "Please provide a human readable name for your site config feature"
read site_config_feature_name
echo "Please provide a machine name for your site config feature. Use lowercase characters and underscores only"
read site_config_feature_machine_name

# Create the site config feature directory structure and files
mkdir $site_config_feature_machine_name
cd $site_config_feature_machine_name
touch $site_config_feature_machine_name.info
touch $site_config_feature_machine_name.install
touch $site_config_feature_machine_name.module

# Fill the blank .module file
echo "<?php" > $site_config_feature_machine_name.module
echo "/**" >> $site_config_feature_machine_name.module
echo " *" >> $site_config_feature_machine_name.module
echo " * @file" >> $site_config_feature_machine_name.module
echo " * Drupal needs this blank file" >> $site_config_feature_machine_name.module
echo " */" >> $site_config_feature_machine_name.module

# Write some help text in the blank .install file
echo "<?php" > $site_config_feature_machine_name.install
echo "/**" >> $site_config_feature_machine_name.install
echo " * For each change that requires actions to be performed when updating a site" >> $site_config_feature_machine_name.install
echo " * add a new hook_update_N()." >> $site_config_feature_machine_name.install
echo " *" >> $site_config_feature_machine_name.install
echo " * Implementations of hook_update_N() are named (module name)_update_(number)" >> $site_config_feature_machine_name.install
echo " * See Drupal.org for more information: https://api.drupal.org/api/drupal/modules%21system%21system.api.php/function/hook_update_N/7" >> $site_config_feature_machine_name.install
echo " */" >> $site_config_feature_machine_name.install

# Fill in the .info file information
echo "name = " $site_config_feature_name > $site_config_feature_machine_name.info
echo "description = Manages dependencies and general settings for the site" >> $site_config_feature_machine_name.info
echo "core = 7.x" >> $site_config_feature_machine_name.info
echo "version = 7.x-1.0" >> $site_config_feature_machine_name.info

# Set up module dependencies
for module in $module_list
do
  echo "dependencies[] = " $module >> $site_config_feature_machine_name.info
done


