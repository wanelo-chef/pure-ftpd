package 'pure-ftpd'

group 'ftpd'

user 'ftpd' do
  home '/var/data/ftp'
  gid 'ftpd'
  shell '/bin/false'
  supports manage_home: true
end

directory '/var/data/ftp' do
  owner 'ftpd'
  group 'ftpd'
  mode 0733
end

directory '/var/run/pure-ftpd' do
  owner 'ftpd'
  group 'ftpd'
  mode 0755
end

service 'pure-ftpd' do
  supports enable: true, reload: true, restart: true, disable: true
end

# add -E to only allow authenticated login
# add -e to only allow anonymous login

cmd = ['pure-ftpd']
cmd << '--pidfile /var/run/pure-ftpd/pure-ftpd.pid'
cmd << '--noanonymous' if node['pure_ftpd']['disable_anonymous_users']
cmd << '--login puredb:/opt/local/etc/pureftpd.pdb' if File.exists?('/opt/local/etc/pureftpd.pdb')
#cmd << '-R' # disallow users to CHMOD
cmd << '--daemonize' # daemonize

smf 'pure-ftpd' do
  user 'ftpd'
  group 'ftpd'
  start_command cmd.join(' ')

  working_directory '/var/data/ftp'
  environment 'PATH' => '/opt/local/bin:/opt/local/sbin'
  notifies :restart, 'service[pure-ftpd]'
end
