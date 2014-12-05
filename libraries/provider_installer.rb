require 'chef/provider'
require 'chef/mixin/shell_out'

class Chef
  class Provider
    #
    # pure_ftpd_installer provider
    #
    class PureFtpdInstaller < Chef::Provider
      def load_current_resource
      end

      def action_run
        if new_resource.installed?
          new_resource.updated_by_last_action(false)
        else
          download_tarfile
          untar_source_tarball
          configure
          make
        end
      end

      def configure
        execute 'configure pure-ftpd' do
          command configure_command.join(' ')
          cwd new_resource.source_directory
          environment 'CFLAGS' => new_resource.cflags,
                      'LDFLAGS' => new_resource.ldflags
        end
      end

      def configure_command
        %W(
          ./configure --with-everything --sysconfdir=#{node['paths']['etc_dir']}
          --localstatedir=/var --with-ldap --with-tls
          --with-certfile=#{node['paths']['etc_dir']}/openssl/private/pure-ftpd.pem
          --with-rfc2640 --with-libintl-prefix=#{node['paths']['prefix_dir']}
          --with-libiconv-prefix=#{node['paths']['prefix_dir']}
          --prefix=#{node['paths']['prefix_dir']} --mandir=#{node['paths']['prefix_dir']}/man
          --with-nonroot
          --with-uploadscript
        )
      end

      def make
        execute 'make pure-ftpd' do
          command 'make && make install'
          cwd new_resource.source_directory
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
