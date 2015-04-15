<?php

/**
 * @file
 * Default drush aliases.drushrc.php file.
 */

/**
 * These are the default configuration so that
 * everyone can just overwrite the different settings.
 */

$aliases['dev'] = array(
 'uri' => 'example.lan',
 'root' => str_replace('drush/aliases', 'docroot', dirname(__FILE__)),
);

$aliases['stage'] = array(
  'uri' => 'stage.example.com',
  'root' => '/var/www/stage.example.com/docroot',
  'remote-host' => 'example.com',
  'remote-user' => 'user',
);

$aliases['live'] = array(
  'uri' => 'example.com',
  'root' => '/var/www/stage.example.com/docroot',
  'remote-host' => 'example.com',
  'remote-user' => 'user',
);



/**
 * A sample Acquia alias
 */

if (!isset($drush_major_version)) {
  $drush_version_components = explode('.', DRUSH_VERSION);
  $drush_major_version = $drush_version_components[0];
}

// Site urban, environment dev
$aliases['dev'] = array(
  'root' => '/var/www/html/example.dev/docroot',
  'ac-site' => 'example',
  'ac-env' => 'dev',
  'ac-realm' => 'prod',
  'uri' => 'example.prod.acquia-sites.com',
  'remote-host' => 'staging-8343.prod.hosting.acquia.com',
  'remote-user' => 'example.dev',
  'path-aliases' => array(
    '%drush-script' => 'drush' . $drush_major_version,
  )
);
$aliases['dev.livedev'] = array(
  'parent' => '@urban.dev',
  'root' => '/mnt/gfs/urban.dev/livedev/docroot',
);
