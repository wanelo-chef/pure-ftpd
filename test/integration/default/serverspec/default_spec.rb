require 'spec_helper'

RSpec.describe 'pure-ftpd::default' do
  describe user('ftpd') do
    it { should exist }
  end

  describe group('ftpd') do
    it { should exist }
  end

  {
    '/var/data/ftp' => 733,
    '/opt/local/etc/pure-ftpd' => 700,
    '/var/run/pure-ftpd' => 755 }.each_pair do |dir, mode|
    describe file(dir) do
      it { should be_directory }
      it { should be_owned_by('ftpd') }
      it { should be_mode(mode) }
    end
  end

  {
    '/opt/local/etc/pure-ftpd/pureftpd.passwd' => 660,
    '/opt/local/etc/pure-ftpd/pureftpd.pdb' => 600 }.each_pair do |fil, mode|
    describe file(fil) do
      it { should be_file }
      it { should be_owned_by('ftpd') }
      it { should be_mode(mode) }
    end
  end

  describe file('/var/run/pure-ftpd/pure-ftpd.upload.pipe') do
    xit { should be_pipe }
  end

  describe service('pure-ftpd') do
    it { should be_running }
  end
end
