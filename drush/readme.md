#Drush configurations

##How to use this directory

Drush doesn't by default know to search this directory. To work around that we need
to add this snippet to our local drushrc.php file. You can find this file in your `~/.drush` directory.

```php
// Load a drushrc.php file from the 'drush' folder at the root of the current
// git repository.
if ($repo_root = _drushrc_find_repo_root()) {
  drush_set_context('DRUSH_REPO_ROOT', $repo_root);
  if (is_dir($repo_root . '/drush')) {
    if (is_file($repo_root . '/drush/drushrc.php')) {
      $options['config'] = $repo_root . '/drush/drushrc.php';
    }
    if (is_dir($repo_root . '/drush/commands')) {
      $options['include'] = $repo_root . '/drush/commands';
    }
    if (is_dir($repo_root . '/drush/aliases')) {
      $options['alias-path'] = $repo_root . '/drush/aliases';
    }
  }
}

/**
 * Attempt to find the root directory of a Git clone.
 *
 * @param string $directory
 *   The directory that may be inside a Git checkout.
 *
 * @return string|bool
 *   The Git root directory if found, or FALSE otherwise.
 */
function _drushrc_find_repo_root($directory = NULL) {
  if (!isset($directory)) {
    $directory = drush_locate_root();
  }

  if (!is_dir($directory)) {
    return FALSE;
  }

  $success = drush_shell_cd_and_exec($directory, 'git rev-parse --show-toplevel 2> ' . drush_bit_bucket());
  if ($success) {
    $output = drush_shell_exec_output();
    return $output[0];
  }
  return FALSE;
}
```

If this file doesn't exist, feel free to create one.
Don't forget to begin the file with a `<?php` tag.
Once the above snippet is in our drushrc.php file then drush will know to read our
custom drushrc.php and to search our commands and aliases directory for commands
and aliases.

###Aliases
The aliases directory is used to store aliases specific to your project. This is a great
place to share aliases such as _@example.staging_, _@example.live_, _@example.rc_ etc..

Be cautious about not storing local specific alias because they probably wont work in
every environment.

###Commands
The commands directory is used to store drush commands you would like to share
with your entire team. This is a great place for your custom drush xyz command.

By default we include the __Registry Rebuild__ and __Build__ commands.

####Registry Rebuild
Instead of trying to explain what it does. Here's a snippet from its [project
page](http://drupal.org/project/registry_rebuild).

>>There are times in Drupal 7 when the registry gets hopelessly hosed and you need to rebuild the registry
 (a list of PHP classes and the files they go with). Sometimes, though, you can't do this regular
 cache-clear activity because some class is required when the system is trying to bootstrap.

####Build
The build command is nothing but a simple drush commands that calls other drush commands
such as updatedb, features-revert-all, and cache-clear. The reason for the build command
is to guarantee your deployment is always being executed in the way you intended. Here's
what the drush command essentially translates to.

    drush updatedb
    drush features-revert-all --force
    drush cc all

But instead of of calling all those commands in the same order all the time you can now
call _drush build --yes_.

