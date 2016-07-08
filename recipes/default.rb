#include_recipe 'redis'
#include_recipe 'redis::server'
package 'git'
include_recipe 'eldus-hubot'
javascript_runtime '0.12'
%w{yo hubot}.each do |pkg|
  node_package pkg
end
directory '/tmp/hubot' do
  recursive true
end
directory '/tmp/jhubot' do
  recursive true
end
git '/tmp/hubot' do
  repository 'https://github.com/github/hubot.git'
  revision 'master'
end
git '/tmp/jhubot' do
  repository 'https://github.com/ldesiqueira/eldus-hubot.git'
  revision 'master'
end

