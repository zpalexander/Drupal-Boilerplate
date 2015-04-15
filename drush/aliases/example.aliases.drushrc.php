<?php

/**
 * @file
 * Default drush aliases.drushrc.php file.
 */

// Grab the most recent major version of Drush
if (!isset($drush_major_version)) {
  $drush_version_components = explode('.', DRUSH_VERSION);
  $drush_major_version = $drush_version_components[0];
}

/**
 * A sample local alias
 */
$aliases['local'] = array(
  'parent' => '@parent',
  'site' => 'example',
  'env' => 'local',
  'uri' => 'example.dev',
  'root' => '/home/vagrant/sites/example',
  'path-aliases' => array(
    '%dump-dir' => '/tmp'
  ),
);


/**
 * A sample Pantheon alias
 *
 * How to get Pantheon aliases: https://pantheon.io/docs/articles/local/drush-command-line-utility/
 */
$aliases['example.dev'] = array(
  'uri' => 'example.gotpantheon.com',
  'db-url' => 'mysql://pantheon:02dba546a64c48bfa103347c00a423f56@dbserver.dev.84ce74ad-9cf0-4584-86e2-2e5f16a0febb.drush.in:10376/pantheon',
  'db-allows-remote' => TRUE,
  'remote-host' => 'appserver.dev.84ce74ad-9cf0-4593-86e2-2e5f16a0febb.drush.in',
  'remote-user' => 'dev.84ce74ad-9cf0-4593-86e2-2e5f16a0febb',
  'ssh-options' => '-p 2222 -o "AddressFamily inet"',
  'path-aliases' => array(
    '%files' => 'code/sites/default/files',
    '%drush-script' => 'drush' . $drush_major_version,
   ),
);


/**
 * A sample Acquia alias
 *
 * How to get Acquia aliases: https://docs.acquia.com/cloud/drush-aliases
 */
$aliases['dev'] = array(
  'root' => '/var/www/html/example.dev/docroot',
  'ac-site' => 'example',
  'ac-env' => 'dev',
  'ac-realm' => 'prod',
  'uri' => 'example.prod.acquia-sites.com',
  'remote-host' => 'develop-8343.prod.hosting.acquia.com',
  'remote-user' => 'example.dev',
  'path-aliases' => array(
    '%drush-script' => 'drush' . $drush_major_version,
  )
);
$aliases['dev.livedev'] = array(
  'parent' => '@example.dev',
  'root' => '/mnt/gfs/urban.dev/livedev/docroot',
);
