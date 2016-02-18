#
# Cookbook Name:: awscli
# Recipe:: _credentials
#
# Copyright 2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
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

if users = node['awscli']['users']
  users.each do |user|
    aws_dir = File.join(node['etc']['passwd']["#{user['name']}"]['dir'], '.aws')
    directory aws_dir do
      owner user['name']
      group user['name']
    end
    template File.join(aws_dir,'credentials') do
      source 'credentials.erb'
      mode '0600'
      owner user['name']
      group user['name']
      variables lazy {{ :user => user }}
    end
    if node['awscli']['config']
      template File.join(aws_dir,'config') do
        source 'config.erb'
        mode '0600'
        owner user['name']
        group user['name']
      end
    end
  end
end
