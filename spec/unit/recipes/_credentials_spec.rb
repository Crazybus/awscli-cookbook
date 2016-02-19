# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.
#
require_relative '../spec_helper'

describe 'awscli::_credentials' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      :platform => 'ubuntu',
      :version => '14.04'
    )
  end
  it 'creates the .aws directory' do
    chef_run.node.set['etc']['passwd']["root"]['dir'] = '/root'
    chef_run.node.set['awscli']['users'] = [{ 'name' => 'root', 'id' => '123456', 'key' => 'sdfklsdj/lfkLDKSJAFlkj213' }]
    chef_run.converge(described_recipe)
    expect(chef_run).to create_directory('/root/.aws').with_owner('root').with_group('root')
  end
  it 'creates a credentials file' do
    chef_run.node.set['etc']['passwd']["root"]['dir'] = '/root'
    chef_run.node.set['awscli']['users'] = [{ 'name' => 'root', 'id' => '123456', 'key' => 'sdfklsdj/lfkLDKSJAFlkj213' }]
    chef_run.converge(described_recipe)
    cred_template = <<-HERE
[default]
aws_access_key_id = 123456
aws_secret_access_key = sdfklsdj/lfkLDKSJAFlkj213
    HERE
    expect(chef_run).to render_file('/root/.aws/credentials').with_content(cred_template)
  end
  it 'creates a config file' do
    chef_run.node.set['etc']['passwd']["root"]['dir'] = '/root'
    chef_run.node.set['awscli']['users'] = [{ 'name' => 'root', 'id' => '123456', 'key' => 'sdfklsdj/lfkLDKSJAFlkj213' }]
    chef_run.node.set['awscli']['config'] = { 'region' => 'eu-nl-prod01', 'test-var' => 'value' }
    chef_run.converge(described_recipe)
    cred_template = <<-HERE
[default]
region = eu-nl-prod01
test-var = value
    HERE
    expect(chef_run).to render_file('/root/.aws/config').with_content(cred_template)
  end
  it 'creates environment variables' do
    chef_run.node.set['awscli']['env_vars'] = { 'S3_ENDPOINT' => 'http://s3.endpoint', 'S3_KEY' => 'value' }
    chef_run.converge(described_recipe)
    template = <<-HERE
export S3_ENDPOINT=http://s3.endpoint
export S3_KEY=value
    HERE
    expect(chef_run).to render_file('/etc/profile.d/awscli.sh').with_content(template)
  end
end
