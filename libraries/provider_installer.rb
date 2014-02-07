require 'chef/provider'
require 'chef/mixin/shell_out'

class Chef
  class Provider
    class PureFtpdInstaller < Chef::Provider

      def load_current_resource
      end

      def action_run
        download_tarfile
        untar_source_tarball
        configure
        make
      end

      def configure
        configure = ['./configure']
        configure << '--with-everything'
        configure << "--sysconfdir=#{node['paths']['etc_dir']}"
        configure << '--localstatedir=/var'
        configure << '--with-ldap'
        configure << '--with-mysql'
        configure << '--with-pgsql'
        configure << '--with-tls'
        configure << "--with-certfile=#{node['paths']['etc_dir']}/openssl/private/pure-ftpd.pem"
        configure << '--with-rfc2640'
        configure << "--with-libintl-prefix=#{node['paths']['prefix_dir']}"
        configure << "--with-libiconv-prefix=#{node['paths']['prefix_dir']}"
        configure << "--prefix=#{node['paths']['prefix_dir']}"
        configure << "--mandir=#{node['paths']['prefix_dir']}/man"
        configure << '--with-nonroot'

        execute 'configure pure-ftpd' do
          command configure.join(' ')
          cwd new_resource.source_directory
          environment 'CFLAGS' => new_resource.cflags,
                      'LDFLAGS' => new_resource.ldflags
          not_if { new_resource.installed? }
        end
      end

      def make
        execute 'make pure-ftpd' do
          command 'make && make install'
          cwd new_resource.source_directory
          not_if { new_resource.installed? }
        end
      end

      def untar_source_tarball
        execute 'untar pure-ftpd' do
          command "tar -xzf #{new_resource.source_tarfile}"
          cwd Chef::Config[:file_cache_path]
          not_if "test -d #{new_resource.source_directory}"
        end
      end

      def download_tarfile
        remote_file new_resource.source_tarfile do
          source node['pure_ftpd']['source_url']
          checksum node['pure_ftpd']['source_checksum']
        end
      end
    end
  end
end
