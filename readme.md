#Drupal Boilerplate#

Drupal boilerplate serves as a boilerplate directory structure for
new Drupal projects.

Drupal boilerplate seeks to standardize new Drupal projects by having the most common
directory structures and files already included and set up.


##Orientation##

Here's a breakdown for what each directory/file is used for. If you want to know more please
read the readme inside the specific directory.

* bin
 * Contains project installation scripts. Feel free to add your own or modify as necessary.
* docroot
 * Where your drupal root should start.
* drush
 * Contains project specific drush commands, aliases, and configurations.
* test-results
 * This directory is just used to export test results to. A good example of this
   is when running drush test-run with the --xml option. You can export the xml
   to this directory for parsing by external tools.
* scripts
 * A directory for project-specific PHP scripts.
* test
 * A directory for external tests. This is great for non-Drupal specific tests
 such as selenium, qunit, casperjs.
* .gitignore
 * Contains the a list of the most common excluded files.


##Starting a Project##

This boilerplate provides installation scripts for Pantheon and Acquia hosted projects, as well as a partial installation script for other projects.

These scripts assume that you will be running your development environment within [VDD](https://www.drupal.org/project/vdd).

***ACQUIA / PANTHEON***

To begin an Acquia or Pantheon hosted project, follow these steps:
* Navigate to the Acquia or Pantheon website, log in and create a new "site". Leave your browser window open.
* Edit your VDD's `config.json` file to [declare the new site](https://www.drupal.org/node/2304391), and run `vagrant provision`. Add the site's URL to your host's `/etc/hosts/`.
* Download and unpack Drupal BoilerPlate into VDD's `/data` directory. Make sure that the directory structure matches what you declared in `config.json`.
* Navigate back to your browser window and use git to clone your new Acquia or Pantheon site into Drupal BoilerPlate's `/docroot` directory. Remove the git files of the repository after cloning it.
* Download your [Acquia](https://docs.acquia.com/cloud/drush-aliases) or [Pantheon](https://pantheon.io/docs/articles/local/drush-command-line-utility/) site's drush aliases. Follow the steps in Drupal BoilerPlate's `/drush` directory to set up aliases for the project.
* SSH into the Vagrant machine. Navigate to `~/sites/your-site/bin` and run `./setup-new-project.sh` to scaffold your new project with commonly used contrib modules, a sub-theme and a site config feature. Select "No" when asked if you want to download Drupal.
* Once `setup-new-project.sh` has completed, run `./acquia-install.sh` or `./pantheon-install.sh` (depending on your host) to install your local site, sync your database and files, and set up Compass in your sub-theme.
* Finally, check to make sure everything has gone well by navigating to your new development site's URL. When you are satisfied, delete the scripts you don't need. Then, navigate to the root of the project, run `git init`, add the project's GitHub repository as a remote, commit all the files and push master to GitHub.


***Unknown Hosting***

To begin a non Acquia/Pantheon hosted project, follow these steps:
* Edit your VDD's `config.json` file to [declare the new site](https://www.drupal.org/node/2304391), and run `vagrant provision`. Add the site's URL to your host's `/etc/hosts/`.
vagrant provision`. Add the site's URL to your host's `/etc/hosts/`.
* Download and unpack Drupal BoilerPlate into VDD's `/data` directory. Make sure that the directory structure matches what you declared in `config.json`.
* Add any drush aliases relevant to the project in the `/drush` directory.
* SSH into the Vagrant machine. Navigate to `~/sites/your-site/bin` and run `./setup-new-project.sh` to scaffold your new project with commonly used contrib modules, a sub-theme and a site config feature. Select "Yes" when asked if you want to download Drupal.
* Once `setup-new-project.sh` has completed, edit `fresh-install.sh` to include any drush sync commands necessary to sync the site's database and files with your hosted site. Then, run `./fresh-install.sh` to install Drupal and set up Compass in your sub-theme.
* Finally, check to make sure everything has gone well by navigating to your new development site's URL. When you are satisfied, delete the scripts you don't need. Then, navigate to the root of the project, run `git init`, add the project's GitHub repository as a remote, commit all the files and push master to GitHub.
