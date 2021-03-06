# Class: mcollective::plugins
#
#   This class deploys the default set of MCollective
#   plugins
#
# Parameters:
#
# Actions:
#
# Requires:
#
#   Class['mcollective']
#   Class['mcollective::service']
#
# Sample Usage:
#
#   This class is intended to be declared in the mcollective class.
#
class mcollective::plugins(
  $plugin_base = $mcollective::params::plugin_base,
  $plugin_subs = $mcollective::params::plugin_subs
) inherits mcollective::params {

  File {
    owner => '0',
    group => '0',
    mode  => '0644',
  }

  # $plugin_base and $plugin_subs are meant to be arrays.
  file { $plugin_base:
    ensure  => directory,
    require => Class['mcollective::server::package'],
  }
  file { $plugin_subs:
    ensure => directory,
    notify => Class['mcollective::server::service'],
  }

  
  mcollective::plugins::plugin { 'facter':
    ensure      => present,
    type        => 'facts',
    override_rb => 'facter_facts'
  } 
  mcollective::plugins::plugin { 'service':
    ensure      => present,
    type        => 'agent',
    ddl         => true,
    application => false,
    override_rb => 'puppet-service'
  }
  mcollective::plugins::plugin { 'package':
    ensure      => present,
    type        => 'agent',
    ddl         => true,
    application => false,
    override_rb => 'puppet-package'
  }
  mcollective::plugins::plugin { 'meta':
    ensure      => present,
    type        => 'registration',
    ddl         => false,
    application => false,
  }
  # Add the NRPE Agent by default
  mcollective::plugins::plugin { 'nrpe':
    ensure      => present,
    type        => 'agent',
    ddl         => true,
    application => false,
  }

}

