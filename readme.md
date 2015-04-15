#Drupal Boilerplate#
-

Drupal boilerplate serves as a directory structure boilerplate for
starting a new Drupal project.

Drupal boilerplate seeks to standardize new Drupal projects by having the most common
directory structures and files already included and set up.

##Getting started##


Here's a breakdown for what each directory/file is used for. If you want to know more please
read the readme inside the specific directory.

* docroot
 * Where your drupal root should start.
* drush
 * Contains project specific drush commands, aliases, and configurations.
* test-results
 * This directory is just used to export test results to. A good example of this
   is when running drush test-run with the --xml option. You can export the xml
   to this directory for parsing by external tools.
* scripts
 * A directory for project-specific scripts.
* test
 * A directory for external tests. This is great for non drupal specific tests
 such as selenium, qunit, casperjs.
* .gitignore
 * Contains the a list of the most common excluded files.


