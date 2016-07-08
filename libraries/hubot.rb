require 'poise'
require 'chef/resource'
require 'chef/provider'

module Hubot
  class Resource < Chef::Resource
    include Poise
    provides  :hubot
    actions   :install, :delete
    attribute :name, name_attribute: true
    attribute :user, default: 'root'
    attribute :group, default: 'root'
    attribute :mode, default: 0777
    attribute :cache, default: ::File.join(Chef::Config[:file_cache_path], 'eldus', 'hubot')
    attribute :app_dir, default: ::File.join('/apps/', 'myapp')
    attribute :install_method, default: :github
    attribute :template, default: 'app.erb'
    attribute :context, default: {:configuration => [
      {:key=> 'debug', :val => 'true'}
    ]}
  end
  class Provider < Chef::Provider
    include Poise
    provides :hubot
    def common
      [new_resource.cache].each do |dir|
        directory dir do
          recursive true
        end
      end
      yield
    end
    def action_install
      common do
      case new_resource.install_method
      when :github
        nil
      end
      end
    end
    def action_delete
      common do
        nil
      end
    end
  end
end
