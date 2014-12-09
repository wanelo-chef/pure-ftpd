include_recipe 'test-setup::_node'
include_recipe 'test-setup::_fixture'
include_recipe 'pure-ftpd::default'

pure_ftpd_virtual_user 'basic ftp user' do
  username node['test_setup']['ftp_user']
  password node['test_setup']['ftp_password']
end
