require 'spec_helper'
require 'net/ftp'

RSpec.describe 'pure_ftpd::virtual_user provider' do
  let(:username) { node['test_setup']['ftp_user'] }
  let(:password) { node['test_setup']['ftp_password'] }

  let(:uploaded_filename) { "/var/data/ftp/#{username}/fixture.txt" }
  let(:uploaded_file) { file(uploaded_filename) }

  before do
    File.unlink(uploaded_filename) if uploaded_file.file?
    Net::FTP.open(node['ipaddress']) do |ftp|
      ftp.login(username, password)
      ftp.put('/tmp/fixture.txt')
    end
  end

  it 'can upload files as user' do
    expect(uploaded_file).to be_file
  end
end
