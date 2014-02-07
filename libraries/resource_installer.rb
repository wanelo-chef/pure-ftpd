require 'chef/resource'
require 'chef/mixin/shell_out'

class Chef
  class Resource
    class PureFtpdInstaller < Chef::Resource
      include Chef::Mixin::ShellOut

      def initialize(name, run_context=nil)
        super
        @resource_name = :pure_ftpd_installer
        @provider = Chef::Provider::PureFtpdInstaller
        @action = :run
        @allowed_actions = [:run]
      end

      def installed?
        check = shell_out('which', 'pure-ftpd', environment: {'PATH' => node['paths']['bin_path']})
        check.exitstatus == 0
      end

      def source_filename
        @filename ||= ::File.basename(node['pure_ftpd']['source_url'])
      end

      def source_tarfile
        @tarfile ||= "#{Chef::Config[:file_cache_path]}/#{source_filename}"
      end

      def source_directory
        @dir ||= "#{Chef::Config[:file_cache_path]}/#{source_filename.gsub(/\.tar\.gz/, '')}"
      end

      def cflags
        '-O2 -pipe -O2 -DLDAP_DEPRECATED -I/opt/local/include -I/usr/include -I/opt/local/include/mysql -I/opt/local/include/gettext'
      end

      def ldflags
        '-L/opt/local/gcc47/lib/gcc/x86_64-sun-solaris2.11/4.7.3 -Wl,-R/opt/local/gcc47/lib/gcc/x86_64-sun-solaris2.11/4.7.3 -L/opt/local/gcc47/lib -Wl,-R/opt/local/gcc47/lib -L/opt/local/lib -Wl,-R/opt/local/lib -L/usr/lib/amd64 -Wl,-R/usr/lib/amd64'
      end
    end
  end
end
