<?php
/**
 * @file
 * Implements some developer commands.
 */


/**
 * Implements hook_drush_command().
 */
function build_drush_command() {
  $items = array();

  $items['build'] = array(
    'description' => 'Runs database updates, reverts features and clears caches.',
    'callback' => '_drush_build',
    'bootstrap' => DRUSH_BOOTSTRAP_DRUPAL_FULL,
  );

  return $items;
}

/**
 * Executes the build commands.
 */
function _drush_build() {
  drush_invoke('updatedb');
  drush_invoke_process('@self', 'features-revert-all', array(), array(
    'force' => TRUE,
    'yes' => TRUE,
  ));
  drush_invoke('cc', array('type' => 'all'));
  drush_log(dt('Built!'), 'success');
}
