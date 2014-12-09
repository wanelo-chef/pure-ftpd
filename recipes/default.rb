include_recipe 'smf'
include_recipe 'pure-ftpd::install'

ftpuser = node['pure_ftpd']['system_user']
ftpgroup = node['pure_ftpd']['system_group']
ftphome = node['pure_ftpd']['home']

group ftpgroup

directory '/var/data'

user ftpuser do
  home ftphome
  gid ftpgroup
  shell '/bin/false'
  supports manage_home: true
end

directory ftphome do
  owner ftpuser
  group ftpgroup
  mode 0733
end

directory '/opt/local/etc/pure-ftpd' do
  owner ftpuser
  group ftpgroup
  mode 0700
end

directory '/var/run/pure-ftpd' do
  owner ftpuser
  group ftpgroup
  mode 0755
end

execute 'touch the pure-ftpd passwd file' do
  command 'umask 0117; touch /opt/local/etc/pure-ftpd/pureftpd.passwd'
  user ftpuser
  group ftpgroup
  not_if { File.exist?('/opt/local/etc/pure-ftpd/pureftpd.passwd') }
end

execute 'initialize pure-ftpd virtual user database' do
  command 'pure-pw mkdb /opt/local/etc/pure-ftpd/pureftpd.pdb -f /opt/local/etc/pure-ftpd/pureftpd.passwd'
  user ftpuser
  group ftpgroup
  not_if { File.exist?('/opt/local/etc/pure-ftpd/pureftpd.pdb') }
end

cmd = ['pure-ftpd']
cmd << '--pidfile /var/run/pure-ftpd/pure-ftpd.pid'
cmd << '--noanonymous' if node['pure_ftpd']['disable_anonymous_users']
cmd << '--login puredb:/opt/local/etc/pure-ftpd/pureftpd.pdb'
cmd << '--nochmod' if node['pure_ftpd']['disable_chmod']
cmd << '--bind 0.0.0.0,21'
cmd << '--chrooteveryone'
cmd << '--createhomedir'
cmd << '--dontresolve'
cmd << '--uploadscript'
cmd << '--brokenclientscompatibility'
cmd << '--daemonize'

smf 'pure-ftpd' do
  user ftpuser
  group ftpgroup
  start_command cmd.join(' ')

  working_directory ftphome
  environment 'PATH' => '/opt/local/bin:/opt/local/sbin'
  notifies :restart, 'service[pure-ftpd]'
end

service 'pure-ftpd' do
  supports enable: true, reload: true, restart: true, disable: true
end
