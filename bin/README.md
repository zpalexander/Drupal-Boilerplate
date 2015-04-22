#Installation Scripts

##Included in this directory

* setup-new-project.sh
  * This script scaffolds Drupal within `/docroot`. First, it optionally download Drupal for you. Then, it downloads the contrib modules you specify in the `module-list` file. Subsequently, it downloads an admin theme as well as some common base themes. It then scaffolds a site config feature for you. Finally, it optionally runs a scaffolder to create a child theme for your project. Meant to be used when starting a new Drupal project.
* generate-config-feature.sh
  * This script is called within `setup-new-project.sh`, but can also be called on its own. It generates a site configuration module which can be used to hold all of the dependencies and general configuration options for your site
* fresh-install.sh
  * This script installs Drupal, enables the site configuration module for the project and sets up Compass in the project's child theme. Meant to be used by a developer ramping up on a project that is not hosted on Acquia or Pantheon. No DB or file sync provided.
* acquia-install.sh
  * This script installs Drupal, syncs the local database and files with the Acquia site and sets up Compass in the project's child theme. Meant to be used by a developer ramping up on an Acquia-hosted project.
* pantheon-install.sh
  * This script installs Drupal, syncs the local database and files with the Pantheon site and sets up Compass in the project's child theme. Meant to be used by a developer ramping up on a Pantheon-hosted project.

##Usage

All of these scripts should be run within the Vagrant machine.
After the correct install script has been chosen for the project, all other install scripts should be deleted from the project's repository.

***setup-new-project.sh*** should only be used by a lead developer to scaffold a new Drupal project prior to the project's first commit. It should be deleted from the project's repository thereafter.

***generate-config-feature.sh*** should not be called on its own, but should be run via `setup-new-project.sh` and deleted from the project's repository thereafter.

***acquia-install.sh*** should be run by a developer who has just cloned the repo of an Acquia-hosted project and wishes to set up the environment to begin development.

***pantheon-install.sh*** should be run by a developer who has just cloned the repo of a Pantheon-hosted project and wishes to set up the environment to begin development.

***fresh-install.sh*** performs the same functions as *acquia-install.sh* and *pantheon-install.sh*, but lacks database sync and file sync commands. In the case of a project which doesn't use Acquia or Pantheon for hosting, this script should be modified to include custom commands to sync the database and the files directory.
