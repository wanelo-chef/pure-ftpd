require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

def load_current_resource

end

action :create do

#  # create home directory for virtual user
#
#
#  # add virtual user
#  cmd = ['pure-pw']
#  cmd << 'useradd'
#  cmd << new_resource.username
#  cmd << "-d /var/data/ftp/#{new_resource.username}"
#  cmd << "-y #{new_resource.max_concurrency}"
#
#
#user_add = shell_out(*cmd)
#user_add.stdin_pipe.write new_resource.password
#user_add.stdin_pipe.write new_resource.password
end
