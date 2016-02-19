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
      :platform => 'windows',
      :version => '2012'
    )
  end

  it 'creates environment variables for windows' do
    chef_run.node.set['awscli']['env_vars'] = { 'S3_ENDPOINT' => 'http://s3.endpoint' }
    chef_run.converge(described_recipe)
    expect(chef_run).to create_env('S3_ENDPOINT')
      .with_value('http://s3.endpoint')
  end
end
